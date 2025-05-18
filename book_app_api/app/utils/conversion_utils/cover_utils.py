from PIL import Image
import io
import numpy as np
from PyPDF2 import PdfReader


def get_cover_from_metadata(doc):
    metadata = doc.metadata
    if '/CoverPage' in metadata:
        return int(metadata['/CoverPage']) - 1
    return None

def detect_cover_page(doc):
    for i in range(min(5, len(doc))):  # Verifică doar primele 5 pagini
        if is_likely_cover(doc[i]):
            print(f"Coperta detectată la pagina {i + 1}")
            return i
    return 0

def is_likely_cover(page, threshold=0.3):
    """Verifică dacă pagina pare a fi copertă"""
    # 1. Verificăm dimensiuni diferite
    if page.rect.width > page.rect.height:  # Layout orizontal
        return True
    
    # 2. Verificăm conținut de imagine
    img_list = page.get_images()
    if img_list:
        return True
    
    # 3. Analiză vizuală (necesită PIL și numpy)
    pix = page.get_pixmap()
    img = Image.open(io.BytesIO(pix.tobytes()))
    arr = np.array(img)
    
    # Calculăm procentul de spații goale (alb)
    white_pixels = np.sum(np.all(arr > 240, axis=-1))
    total_pixels = arr.shape[0] * arr.shape[1]
    white_ratio = white_pixels / total_pixels
    
    return white_ratio < threshold  # Mai puțin spațiu gol = mai probabil copertă


def extract_cover(doc, output_path=None):
    cover_idx = get_cover_from_metadata(doc)
    
    if cover_idx is None:
        cover_idx = detect_cover_page(doc)
    
    cover = doc[cover_idx]
    pix = cover.get_pixmap()
    
    if output_path:
        pix.save(output_path)
        return output_path
    else:
        return pix.tobytes()