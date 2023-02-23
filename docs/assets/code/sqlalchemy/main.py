import os
import sqlalchemy as db
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

engine = db.create_engine(os.environ['DATABASE_URL'])

class Basic(Base):
    __tablename__ = "title_basics"

    tconst = db.Column(db.TEXT, primary_key=True)
    titletype = db.Column(db.TEXT)
    primarytitle = db.Column(db.TEXT)
    originaltitle = db.Column(db.TEXT)
    isadult = db.Column(db.BOOLEAN)
    startyear = db.Column(db.INTEGER)
    endyear = db.Column(db.INTEGER)
    runtimeminutes = db.Column(db.INTEGER)
    genres = db.Column(db.TEXT)

class Rating(Base):
    __tablename__ = "title_ratings"

    tconst = db.Column(db.TEXT, primary_key=True)
    averagerating = db.Column(db.NUMERIC)
    numvotes = db.Column(db.INTEGER)

Session = sessionmaker(bind=engine)
session = Session()

year = 1980
result = session.query(
    Basic.originaltitle, Rating.averagerating). \
    join(Rating, Basic.tconst == Rating.tconst ). \
    filter(Basic.startyear == year). \
    filter(Basic.titletype == 'movie'). \
    filter(Rating.numvotes > 50000). \
    order_by(Rating.averagerating.desc()). \
    limit(10)

print("Year:", year)

for r in result: 
    print(r.originaltitle, "|", r.averagerating)
