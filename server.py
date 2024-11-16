from typing import Union

from fastapi import FastAPI, UploadFile

import json
import imageio
from readmrz import MrzDetector, MrzReader
from PIL import Image
from io import BytesIO
import numpy as np

detector = MrzDetector()
reader = MrzReader()

app = FastAPI()


def load_image_into_numpy_array(data):
    return np.array(Image.open(BytesIO(data)).rotate(180))
 

async def scan(photo: UploadFile): 
    image = load_image_into_numpy_array(await photo.read())
    result = reader.process(image)
    return json.dumps(result)


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/scan-image")
async def scanImage(photo: UploadFile):
    print(photo)
    res = await scan(photo)
    return res
