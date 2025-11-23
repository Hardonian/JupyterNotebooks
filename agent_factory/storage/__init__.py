"""
Storage abstraction layer.

Provides unified interface for different storage backends (local, S3, etc.).
"""

from agent_factory.storage.base import StorageBackend, StorageFile
from agent_factory.storage.local import LocalStorage
from agent_factory.storage.s3 import S3Storage

__all__ = [
    "StorageBackend",
    "StorageFile",
    "LocalStorage",
    "S3Storage",
]
