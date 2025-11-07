import logging
from typing import Dict, List, Any
from apscheduler.schedulers.background import BackgroundScheduler

from jobs.stock_zh_a_hist import stock_zh_a_hist
from jobs.stock_zh_a_spot_em import stock_zh_a_spot_em
from jobs.test_job import TestJob
from jobs.data_cleanup_job import DataCleanupJob

logger = logging.getLogger(__name__)

class JobManager:
    """任务管理器"""
    
    def __init__(self):
        self.scheduler = BackgroundScheduler()
        self.jobs = {}
        self.registered_jobs = []
        
    def register_jobs(self):
        """注册所有任务"""
        # 创建任务实例
        stock_zh_a_hist_job = stock_zh_a_hist()
        stock_zh_a_spot_em_job = stock_zh_a_spot_em()
        test_job = TestJob()
        cleanup_job = DataCleanupJob()
        
        # 注册任务
        self.register_job(stock_zh_a_hist_job)
        self.register_job(stock_zh_a_spot_em_job)
        self.register_job(test_job)
        self.register_job(cleanup_job)
        
        logger.info(f"已注册 {len(self.registered_jobs)} 个定时任务")
        
    def register_job(self, job_instance):
        """注册单个任务"""
        job_config = job_instance.get_job_config()
        
        # 添加到调度器
        scheduled_job = self.scheduler.add_job(
            job_config["func"],
            trigger=job_config["trigger"],
            id=job_config["id"],
            name=job_config["name"]
        )
        
        # 保存任务信息
        self.jobs[job_config["id"]] = {
            "instance": job_instance,
            "config": job_config,
            "scheduled_job": scheduled_job
        }
        
        self.registered_jobs.append(job_config["id"])
        
        logger.info(f"注册任务: {job_config['name']} (ID: {job_config['id']})")
        
    def start_all_jobs(self):
        """启动所有任务"""
        if not self.scheduler.running:
            self.scheduler.start()
            logger.info("定时任务调度器已启动")
            
            # 打印任务状态
            self.print_job_status()
        else:
            logger.warning("定时任务调度器已在运行中")
    
    def stop_all_jobs(self):
        """停止所有任务"""
        if self.scheduler.running:
            self.scheduler.shutdown()
            logger.info("定时任务调度器已停止")
    
    def get_job_status(self) -> Dict[str, Any]:
        """获取任务状态"""
        status = {
            "scheduler_running": self.scheduler.running,
            "registered_jobs": self.registered_jobs,
            "job_details": {}
        }
        
        for job_id in self.registered_jobs:
            job_info = self.jobs[job_id]
            scheduled_job = job_info["scheduled_job"]
            
            # 获取任务的下次运行时间
            next_run_time = None
            try:
                # 从调度器获取任务的下次运行时间
                job = self.scheduler.get_job(job_id)
                if job:
                    next_run_time = job.next_run_time
            except Exception:
                pass
            
            status["job_details"][job_id] = {
                "name": job_info["config"]["name"],
                "description": job_info["config"]["description"],
                "next_run_time": str(next_run_time) if next_run_time else None,
                "trigger": str(scheduled_job.trigger)
            }
        
        return status
    
    def print_job_status(self):
        """打印任务状态"""
        status = self.get_job_status()
        
        logger.info("=== 定时任务状态 ===")
        logger.info(f"调度器状态: {'运行中' if status['scheduler_running'] else '已停止'}")
        logger.info(f"已注册任务数: {len(status['registered_jobs'])}")
        
        for job_id, details in status["job_details"].items():
            logger.info(f"任务: {details['name']}")
            logger.info(f"  - 描述: {details['description']}")
            logger.info(f"  - 下次执行: {details['next_run_time']}")
            logger.info(f"  - 触发器: {details['trigger']}")
    
    def run_job_immediately(self, job_id: str) -> Dict[str, Any]:
        """立即执行指定任务"""
        if job_id not in self.jobs:
            return {
                "success": False,
                "message": f"任务 {job_id} 不存在"
            }
        
        try:
            job_instance = self.jobs[job_id]["instance"]
            result = job_instance.execute()
            
            return {
                "success": True,
                "message": f"任务 {job_id} 执行完成",
                "result": result
            }
            
        except Exception as e:
            logger.error(f"立即执行任务 {job_id} 失败: {e}")
            
            return {
                "success": False,
                "message": f"任务执行失败: {str(e)}"
            }
    
    def pause_job(self, job_id: str) -> bool:
        """暂停任务"""
        if job_id in self.jobs:
            self.jobs[job_id]["scheduled_job"].pause()
            logger.info(f"任务 {job_id} 已暂停")
            return True
        return False
    
    def resume_job(self, job_id: str) -> bool:
        """恢复任务"""
        if job_id in self.jobs:
            self.jobs[job_id]["scheduled_job"].resume()
            logger.info(f"任务 {job_id} 已恢复")
            return True
        return False