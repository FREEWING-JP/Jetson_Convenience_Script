# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
#
# This work is licensed under the Creative Commons Attribution-NonCommercial
# 4.0 International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

"""Minimal script for generating an image using pre-trained StyleGAN generator."""

import os
import pickle
import numpy as np
import PIL.Image
import dnnlib
import dnnlib.tflib as tflib
import config
import sys

def main():
    args = sys.argv
    url = 'https://drive.google.com/uc?id=1MEGjdvVpUsu1jB4zrXZN7Y4kBBOzizDQ'
    if len(args) > 1:
      url = args[1]
    num = 1
    if len(args) > 2:
      num = int(args[2])
    seed = 5
    if len(args) > 3:
      seed = int(args[3])
    pre = ""
    if len(args) > 4:
      pre = args[4]

    # Initialize TensorFlow.
    tflib.init_tf()

    # Load pre-trained network.
    if (url.find('https') == 0):
      # url = 'https://drive.google.com/uc?id=1MEGjdvVpUsu1jB4zrXZN7Y4kBBOzizDQ' # karras2019stylegan-ffhq-1024x1024.pkl
      with dnnlib.util.open_url(url, cache_dir=config.cache_dir) as f:
          _G, _D, Gs = pickle.load(f)
          # _G = Instantaneous snapshot of the generator. Mainly useful for resuming a previous training run.
          # _D = Instantaneous snapshot of the discriminator. Mainly useful for resuming a previous training run.
          # Gs = Long-term average of the generator. Yields higher-quality results than the instantaneous snapshot.
    else:
      # ../2019-02-26-stylegan-faces-network-02048-016041.pkl
      with open(url, "rb") as f:
          _, _, Gs = pickle.load(f)
          # _G = Instantaneous snapshot of the generator. Mainly useful for resuming a previous training run.
          # _D = Instantaneous snapshot of the discriminator. Mainly useful for resuming a previous training run.
          # Gs = Long-term average of the generator. Yields higher-quality results than the instantaneous snapshot.

    # Print network details.
    Gs.print_layers()

    rnd = np.random.RandomState(seed)

    for i in range(num):
      print(i)

      # Pick latent vector.
      # rnd = np.random.RandomState(5)
      latents = rnd.randn(1, Gs.input_shape[1])

      # Generate image.
      fmt = dict(func=tflib.convert_images_to_uint8, nchw_to_nhwc=True)
      images = Gs.run(latents, None, truncation_psi=0.7, randomize_noise=True, output_transform=fmt)

      # Save image.
      os.makedirs(config.result_dir, exist_ok=True)
      # png_filename = os.path.join(config.result_dir, 'example.png')
      png_filename = os.path.join(config.result_dir, pre +'example_'+ str(i).zfill(len(str(num))) +'.png')
      PIL.Image.fromarray(images[0], 'RGB').save(png_filename)

if __name__ == "__main__":
    main()
