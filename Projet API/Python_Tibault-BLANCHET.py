# py -m ensurepip pip install moviepy --upgrade
#  py -m pip install moviepy

import os
import pip._vendor.requests as requests
import moviepy
from moviepy.editor import *
from datetime import datetime
import shutil as shutil


def Creation_vidéo (nbImages, dossier_images, script_dir):
    # Demander à l'utilisateur le nombre d'images souhaité
    nbSeconde = input("Combien voulez-vous que l'image dure ? ")
    clips = []
    for i in range(1, int(nbImages) + 1):
        chemin_image = os.path.join(dossier_images, "image_" + str(i) + ".jpg")
        clip = ImageClip(chemin_image).set_duration(int(nbSeconde))
        clips.append(clip)


    diaporama = concatenate_videoclips(clips)
    dossier_audio = os.path.join(script_dir, "Audio_proj", "MG - TD.mp3")
    musique = AudioFileClip(dossier_audio)
    musique = musique.set_duration(int(nbImages)*int(nbSeconde))
    diaporama = diaporama.set_audio(musique)
    now = datetime.now().strftime('%Y_%m_%d_%H_%M')
    diaporama.write_videofile(os.path.join(script_dir, "Diapo_proj", "Diaporama_"+ str(now) + ".mp4"), fps=24)
    return print("Vidéo crée")

script_dir = os.path.dirname(os.path.abspath(__file__))
print(script_dir)



# Créer dossier (s'il n'existe pas) pour sauvegarder les images
dossier_images = os.path.join(script_dir, "images_picsum")
if os.path.exists(dossier_images) == True :
    shutil.rmtree(dossier_images)
else: 
    os.makedirs(dossier_images)

# Créer dossier (s'il n'existe pas) pour sauvegarder les images
dossier_audio = os.path.join(script_dir, "Audio_proj")
if os.path.exists(dossier_audio) == False :
    os.makedirs(dossier_audio)

# Créer dossier (s'il n'existe pas) pour sauvegarder les images
dossier_diapo = os.path.join(script_dir, "Diapo_proj")
if os.path.exists(dossier_diapo) == False :
    os.makedirs(dossier_diapo)

# Demander à l'utilisateur le nombre d'images souhaité
nbImages = input("Combien voulez-vous d'images ? ")


# Télécharger le nombre d'images aléatoires souhaité
for i in range(1, int(nbImages) + 1):
    # créer l'URL
    url = "https://picsum.photos/800/600?random=" + str(i)
    try:
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            # créer le path d'accès à chaque image
            path_image = os.path.join(dossier_images, "image_" + str(i) + ".jpg")
            # ouvrir le fichier en binaire
            fichier = open(path_image, 'wb')
            # écrire la contenu du retour de la requête
            fichier.write(response.content)
            # fermer le fichier
            fichier.close()
            # témoin de sauvegarde dans la console
            print("Image", str(i), "sauvegardée avec succès !")
    except Exception as e:
        print("Erreur pour l'image", str(i), ":", str(e))

Creation_vidéo(nbImages, dossier_images, script_dir)
# path_fdiapo = os.path.join(dossier_images)
# path_fdiapo = os.path.join(dossier_audio)
# path_fdiapo = os.path.join(dossier_audio)




