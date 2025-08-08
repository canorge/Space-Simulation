from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from skyfield.api import load, Star
from skyfield.data import hipparcos

app = FastAPI()

# Güneş Sistemi cisimleri
planets = load('de421.bsp')

ts = load.timescale()

# Hipparcos yıldız kataloğu
with load.open(hipparcos.URL) as f:
    stars = hipparcos.load_dataframe(f)

class PositionResponse(BaseModel):
    ra: float         # Right Ascension (derece)
    dec: float        # Declination (derece)
    distance_au: float

@app.get("/planet_position/{name}", response_model=PositionResponse)
def get_position(name: str):
    name = name.lower()
    t = ts.now()

    fixed_stars = {
        'polaris': 11767,
    }

    if name in fixed_stars:
        star = Star.from_dataframe(stars.loc[fixed_stars[name]])
        astrometric = planets['earth'].at(t).observe(star)
        ra, dec, distance = astrometric.radec()
        return PositionResponse(
            ra=ra.hours * 15,
            dec=dec.degrees,
            distance_au=distance.au
        )

    # Gezegen kontrolü
    if name not in planets:
        raise HTTPException(status_code=404, detail=f"'{name}' bulunamadı")

    planet = planets[name]
    # Dünya baz alınarak hesaplar
    astrometric = planets['earth'].at(t).observe(planet)
    ra, dec, distance = astrometric.radec()

    return PositionResponse(
        ra=ra.hours * 15,
        dec=dec.degrees,
        distance_au=distance.au
    )
