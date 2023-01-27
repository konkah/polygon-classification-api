import sys
sys.path.insert(1, '/src')

from src.database.triangle import Triangle
from os import environ

from sqlmodel import create_engine, SQLModel, Session
from urllib.parse import quote_plus as urlquote

USER = environ.get("MYSQL_USER")
PASS = urlquote(environ.get("MYSQL_PASSWORD"))
HOST = environ.get("DOCKER_DB_SERVICE")
DB = environ.get("MYSQL_DATABASE")

DATABASE_URL = f"mysql+pymysql://{USER}:{PASS}@{HOST}/{DB}"
engine = create_engine(DATABASE_URL, echo=True)


def init_db():
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
