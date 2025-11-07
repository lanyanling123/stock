from fastapi import APIRouter, HTTPException
from typing import Dict, Any

from jobs.job_manager import JobManager

router = APIRouter()

# 初始化任务管理器
job_manager = JobManager()

@router.post("/jobs/start")
async def start_all_jobs():
    """启动所有定时任务"""
    try:
        job_manager.start_all_jobs()
        
        return {
            "success": True,
            "message": "所有定时任务已启动",
            "status": job_manager.get_job_status()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"启动任务失败: {str(e)}")

@router.post("/jobs/stop")
async def stop_all_jobs():
    """停止所有定时任务"""
    try:
        job_manager.stop_all_jobs()
        
        return {
            "success": True,
            "message": "所有定时任务已停止"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"停止任务失败: {str(e)}")

@router.get("/jobs/status")
async def get_job_status():
    """获取任务状态"""
    try:
        status = job_manager.get_job_status()
        
        return {
            "success": True,
            "data": status
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取任务状态失败: {str(e)}")

@router.post("/jobs/{job_id}/run")
async def run_job_immediately(job_id: str):
    """立即执行指定任务"""
    try:
        result = job_manager.run_job_immediately(job_id)
        
        if not result["success"]:
            raise HTTPException(status_code=404, detail=result["message"])
        
        return result
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"执行任务失败: {str(e)}")

@router.post("/jobs/{job_id}/pause")
async def pause_job(job_id: str):
    """暂停指定任务"""
    try:
        success = job_manager.pause_job(job_id)
        
        if not success:
            raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
        
        return {
            "success": True,
            "message": f"任务 {job_id} 已暂停"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"暂停任务失败: {str(e)}")

@router.post("/jobs/{job_id}/resume")
async def resume_job(job_id: str):
    """恢复指定任务"""
    try:
        success = job_manager.resume_job(job_id)
        
        if not success:
            raise HTTPException(status_code=404, detail=f"任务 {job_id} 不存在")
        
        return {
            "success": True,
            "message": f"任务 {job_id} 已恢复"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"恢复任务失败: {str(e)}")

@router.get("/jobs/list")
async def list_all_jobs():
    """列出所有任务"""
    try:
        status = job_manager.get_job_status()
        
        job_list = []
        for job_id, details in status["job_details"].items():
            job_list.append({
                "id": job_id,
                "name": details["name"],
                "description": details["description"],
                "next_run_time": details["next_run_time"],
                "trigger": details["trigger"]
            })
        
        return {
            "success": True,
            "data": {
                "total": len(job_list),
                "jobs": job_list
            }
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取任务列表失败: {str(e)}")