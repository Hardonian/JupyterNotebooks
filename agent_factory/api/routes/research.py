"""
Research and experimentation API endpoints.
"""

from fastapi import APIRouter, HTTPException, status
from fastapi.responses import JSONResponse
from typing import Optional, List
from agent_factory.research.experiments import (
    get_experiment_tracker,
    Variant,
    VariantType,
    ExperimentStatus,
)
from pydantic import BaseModel

router = APIRouter()


class VariantRequest(BaseModel):
    """Variant request."""
    name: str
    variant_type: str
    config: dict
    allocation_percent: float = 50.0


class ExperimentRequest(BaseModel):
    """Experiment request."""
    name: str
    description: str
    variants: List[VariantRequest]
    created_by: Optional[str] = None


class ResultRequest(BaseModel):
    """Result request."""
    variant_id: str
    success: bool
    metrics: dict
    metadata: Optional[dict] = None


@router.post("/experiments")
async def create_experiment(request: ExperimentRequest):
    """Create an experiment."""
    tracker = get_experiment_tracker()
    
    variants = [
        Variant(
            id="",  # Will be generated
            name=v.name,
            variant_type=VariantType(v.variant_type),
            config=v.config,
            allocation_percent=v.allocation_percent,
        )
        for v in request.variants
    ]
    
    experiment = tracker.create_experiment(
        name=request.name,
        description=request.description,
        variants=variants,
        created_by=request.created_by,
    )
    
    return JSONResponse(
        content={
            "experiment_id": experiment.id,
            "name": experiment.name,
            "status": experiment.status.value,
        },
        status_code=status.HTTP_201_CREATED,
    )


@router.post("/experiments/{experiment_id}/start")
async def start_experiment(experiment_id: str):
    """Start an experiment."""
    tracker = get_experiment_tracker()
    
    try:
        tracker.start_experiment(experiment_id)
        return JSONResponse(content={"status": "started"})
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )


@router.post("/experiments/{experiment_id}/results")
async def record_result(experiment_id: str, request: ResultRequest):
    """Record an experiment result."""
    tracker = get_experiment_tracker()
    
    tracker.record_result(
        experiment_id=experiment_id,
        variant_id=request.variant_id,
        success=request.success,
        metrics=request.metrics,
        metadata=request.metadata,
    )
    
    return JSONResponse(content={"status": "recorded"})


@router.get("/experiments/{experiment_id}/results")
async def get_experiment_results(experiment_id: str):
    """Get experiment results."""
    tracker = get_experiment_tracker()
    
    try:
        results = tracker.get_experiment_results(experiment_id)
        return JSONResponse(content=results)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )


@router.get("/experiments/{experiment_id}/assign")
async def assign_variant(experiment_id: str, user_id: str):
    """Assign a variant to a user."""
    tracker = get_experiment_tracker()
    
    try:
        variant = tracker.assign_variant(experiment_id, user_id)
        return JSONResponse(content={
            "variant_id": variant.id,
            "variant_name": variant.name,
            "variant_type": variant.variant_type.value,
            "config": variant.config,
        })
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )


@router.get("/experiments")
async def list_experiments(
    status: Optional[str] = None,
    created_by: Optional[str] = None,
):
    """List experiments."""
    tracker = get_experiment_tracker()
    
    experiment_status = ExperimentStatus(status) if status else None
    
    experiments = tracker.list_experiments(
        status=experiment_status,
        created_by=created_by,
    )
    
    return JSONResponse(content={
        "experiments": [
            {
                "id": e.id,
                "name": e.name,
                "status": e.status.value,
                "created_at": e.created_at.isoformat(),
            }
            for e in experiments
        ]
    })
