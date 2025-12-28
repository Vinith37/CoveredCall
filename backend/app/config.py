"""
Configuration management using Pydantic Settings.
All configuration loaded from environment variables (.env file).
"""
from pydantic_settings import BaseSettings
from pydantic import Field
from typing import Optional, List


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # Database
    database_url: str = Field(..., env="DATABASE_URL")
    
    # API Configuration
    api_port: int = Field(default=8000, env="PORT")  # Changed from API_PORT to PORT for Railway
    api_host: str = Field(default="0.0.0.0", env="API_HOST")
    
    # CORS - Support multiple origins
    cors_origins: str = Field(
        default="http://localhost:5173",
        env="CORS_ORIGINS",
        description="Comma-separated list of allowed CORS origins"
    )
    
    @property
    def cors_origins_list(self) -> List[str]:
        """Convert comma-separated CORS origins to list."""
        return [origin.strip() for origin in self.cors_origins.split(",")]
    
    # Environment
    environment: str = Field(default="development", env="ENVIRONMENT")
    debug: bool = Field(default=True, env="DEBUG")
    
    # Security - Make SECRET_KEY optional for Railway
    secret_key: str = Field(default="railway-secret-key-change-in-production", env="SECRET_KEY")
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = False
        extra = "ignore"  # Ignore extra fields in .env file


# Global settings instance
settings = Settings()