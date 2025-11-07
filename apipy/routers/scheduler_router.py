from fastapi import APIRouter, HTTPException, Depends
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import os

router = APIRouter()

# 获取模板目录路径
template_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "templates")

# 延迟导入job_manager，避免循环导入
def get_job_manager():
    from main import job_manager
    return job_manager

@router.get("/scheduler", response_class=HTMLResponse)
async def scheduler_dashboard():
    """调度器可视化界面"""
    try:
        with open(os.path.join(template_dir, "scheduler.html"), "r", encoding="utf-8") as f:
            html_content = f.read()
        return HTMLResponse(content=html_content)
    except FileNotFoundError:
        return HTMLResponse(content="<h1>调度器界面文件未找到</h1>", status_code=404)

@router.get("/scheduler/api/jobs")
async def get_scheduler_jobs(job_manager = Depends(get_job_manager)):
    """获取所有任务状态（供前端调用）"""
    jobs_info = []
    
    for job_id in job_manager.registered_jobs:
        job_info = job_manager.jobs.get(job_id, {})
        scheduled_job = job_info.get("scheduled_job")
        
        if scheduled_job:
            jobs_info.append({
                "id": job_id,
                "name": job_info.get("config", {}).get("name", job_id),
                "status": "running" if scheduled_job.next_run_time else "stopped",
                "next_run_time": scheduled_job.next_run_time.isoformat() if scheduled_job.next_run_time else None,
                "trigger": str(scheduled_job.trigger),
                "run_count": 0,  # 需要从任务实例中获取
                "last_run_time": None  # 需要从任务实例中获取
            })
    
    return {"jobs": jobs_info}

@router.post("/scheduler/api/jobs/{job_id}/run")
async def run_job_now(job_id: str, job_manager = Depends(get_job_manager)):
    """立即执行指定任务"""
    if job_id not in job_manager.jobs:
        raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
    
    try:
        result = job_manager.run_job_immediately(job_id)
        
        if result["success"]:
            return {
                "status": "success", 
                "message": result["message"], 
                "result": result.get("result", "")
            }
        else:
            raise HTTPException(status_code=500, detail=result["message"])
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"任务执行失败: {str(e)}")

@router.post("/scheduler/api/jobs/{job_id}/pause")
async def pause_job(job_id: str, job_manager = Depends(get_job_manager)):
    """暂停指定任务"""
    if job_id not in job_manager.jobs:
        raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
    
    if job_manager.pause_job(job_id):
        return {"status": "success", "message": f"任务 {job_id} 已暂停"}
    else:
        raise HTTPException(status_code=500, detail=f"暂停任务 {job_id} 失败")

@router.post("/scheduler/api/jobs/{job_id}/resume")
async def resume_job(job_id: str, job_manager = Depends(get_job_manager)):
    """恢复指定任务"""
    if job_id not in job_manager.jobs:
        raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
    
    if job_manager.resume_job(job_id):
        return {"status": "success", "message": f"任务 {job_id} 已恢复"}
    else:
        raise HTTPException(status_code=500, detail=f"恢复任务 {job_id} 失败")

@router.post("/scheduler/api/jobs/{job_id}/stop")
async def stop_job(job_id: str, job_manager = Depends(get_job_manager)):
    """停止指定任务"""
    if job_id not in job_manager.jobs:
        raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
    
    # 使用JobManager的方法来停止任务
    scheduled_job = job_manager.jobs[job_id].get("scheduled_job")
    if scheduled_job:
        scheduled_job.remove()
        return {"status": "success", "message": f"任务 {job_id} 已停止"}
    else:
        raise HTTPException(status_code=500, detail=f"停止任务 {job_id} 失败")