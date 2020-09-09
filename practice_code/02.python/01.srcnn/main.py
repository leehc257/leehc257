# import cv2
import numpy as np
import tensorflow as tf
from keras.models import Sequential, load_model
from keras.layers import Conv2D
from keras.optimizers import Adam
from random import *

from PIL import Image
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

import os
import datetime
import h5py

from keras.callbacks import ModelCheckpoint


def get_psnr(loss):
    loss = np.array(loss)
    psnr_mat =[]
    for idx in range(len(loss)):
        MSE = loss[idx]**2/(32*32)
        psnr_mat.append(10 * np.log10(255 ** 2 / MSE))
    return psnr_mat

def data_load():
    h_file = h5py.File('dataset_2020-04-10/train_data.hdf5', 'r')
    input_data = h_file.get('input_data')
    label_data = h_file.get('label_data')

    return input_data, label_data

def train():
    #모델 선언
    srcnn_model = model()
    print(srcnn_model.summary())

    #input data load
    input_data, label_data = data_load()

    #random seed는 좀더 공부
    np.random.seed(3)
    tf.set_random_seed(3)

    #train, test 구분
    input_train_tmp, input_test_tmp, label_train_tmp, label_test_tmp = train_test_split(np.array(input_data), np.array(label_data), test_size=0.3, random_state=None)
    input_train = input_train_tmp.reshape( input_train_tmp.shape[0], 32, 32, 1)
    input_test = input_test_tmp.reshape(input_test_tmp.shape[0], 32, 32, 1)
    label_train = label_train_tmp.reshape(label_train_tmp.shape[0], 32, 32, 1)
    label_test = label_test_tmp.reshape(label_test_tmp.shape[0], 32, 32, 1)

    # 모니터링
    MODEL_DIR = './model/'
    if not os.path.exists(MODEL_DIR):
        os.mkdir(MODEL_DIR)
    modelpath = "./model/{epoch:02d}-{val_loss:.4f}.hdf5"
    checkpointer = ModelCheckpoint(filepath=modelpath, monitor='val_loss', verbose=1, save_best_only=True)


    #학습 시작
    history = srcnn_model.fit(input_train, label_train, batch_size = 100, epochs=50, validation_data=(input_test, label_test))

    srcnn_model.save('my_model.h5')

    return history


def model():
    SRCNN = Sequential()
    #conv2d(마스크개수, kernal_size, input_shape, activation)
    SRCNN.add(Conv2D(64, kernel_size=(9,9), input_shape=(32, 32, 1), padding='same', activation='relu', kernel_initializer='glorot_uniform', use_bias='true'))
    SRCNN.add(Conv2D(32, kernel_size=(1,1),                       padding='same', activation='relu', kernel_initializer='glorot_uniform', use_bias='true'))
    SRCNN.add(Conv2D(1, kernel_size=(5,5),                        padding='same',kernel_initializer='glorot_uniform', use_bias='true'))
    adam = Adam(lr=0.0003)
    SRCNN.compile(optimizer=adam, loss='mean_squared_error',metrics=['mean_squared_error'])
    return SRCNN

def crop_test():
    im_gray = Image.open('train/t1.bmp').convert('L') #197x176(가로 x 세로)
    pix = np.array(im_gray)

    im_crop1 = tf.image.random_crop(pix, (32, 32), 1)
    im_crop2 = tf.image.random_crop(pix, (32, 32), 1)
    im_crop3 = tf.image.random_crop(pix, (32, 32), 1)
    fig = plt.figure()
    ax1 = fig.add_subplot(1, 3, 1)
    ax2 = fig.add_subplot(1, 3, 2)
    ax3 = fig.add_subplot(1, 3, 3)
    ax1.imshow(im_crop1)
    ax2.imshow(im_crop2)
    ax3.imshow(im_crop3)
    plt.show()
def bicubic_test():
    im_gray = Image.open('train/t1.bmp').convert('L')  # 197x176(가로 x 세로)
    # pix = np.array(im_gray)
    param_scale = 2
    width, height = im_gray.size
    print(width, height)
    random_row = int(randrange(0, height - 1 - 32, 1))
    random_col = int(randrange(0, width - 1 - 32, 1))
    print(random_row, random_col)

    im_crop_tmp = im_gray.crop((random_row, random_col, random_row+32, random_col+32))

    im_bicubic_tmp = im_crop_tmp.resize((32//param_scale,32//param_scale), Image.BICUBIC )
    im_bicubic = im_bicubic_tmp.resize((32, 32), Image.BICUBIC)

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 2, 1)
    ax2 = fig.add_subplot(1, 2, 2)
    ax1.imshow(im_crop_tmp)
    ax2.imshow(im_bicubic)
    plt.show()

def make_image_set(sample_num, patch_size, scale_size):
    input_data = []
    label_data = []
    path = "./train"
    file_list = os.listdir(path)
    np.random.seed(3)
    tf.set_random_seed(3)
    for file_num in range(len(file_list)): #해당 path에 있는 data 전부
        im_gray = Image.open(path + "/" + file_list[file_num]).convert('L')  # gray scale로 입력
        pix = np.array(im_gray)
        width, height = im_gray.size
        for iter_idx in range(sample_num):
            #data crop
            random_row = int(randrange(0, height - 1 - 32, 1))
            random_col = int(randrange(0, width - 1 - 32, 1))
            im_crop_tmp = im_gray.crop((random_row, random_col, random_row + patch_size, random_col + patch_size))
            # im_crop_tmp = tf.image.random_crop(pix, (patch_size, patch_size), 1) # image, crop_size, seed_opt
            # im_crop = Image.fromarray(np.array(im_crop_tmp)) #array 변환 후 Image 객체로 변환
            im_bicubic_tmp = im_crop_tmp.resize((patch_size//scale_size, patch_size//scale_size), Image.BICUBIC)
            im_bicubic = im_bicubic_tmp.resize((patch_size, patch_size), Image.BICUBIC)

            # data 저장
            input_data.append(np.array(im_bicubic))
            label_data.append(np.array(im_crop_tmp))


    now = datetime.datetime.now()
    nowDate = now.strftime('%Y-%m-%d')
    dataset_path = "dataset_"+ nowDate
    if not os.path.isdir(dataset_path):
        os.mkdir(dataset_path)
    f = h5py.File(dataset_path + "/" + 'train_data.hdf5','w')
    f.create_dataset("input_data", data=input_data)
    f.create_dataset("label_data", data=label_data)


def data_load_test():
    h_file = h5py.File('dataset_2020-04-10/train_data.hdf5','r')
    input_data = h_file.get('input_data')
    label_data = h_file.get('label_data')
    # plt.figure(1)
    # plt.imshow(input_data[0])
    # plt.figure(2)
    # plt.imshow(label_data[0])
    # plt.show()
    return input_data, label_data

def get_psnr_test(img1, img2):
    loss = np.array(img1) - np.array(img2)
    MSE = np.sum(loss ** 2) / (32 * 32)
    psnr_tmp = (10 * np.log10(255 ** 2 / MSE))
    return psnr_tmp

if __name__ == "__main__":
    # input_data, label_data = data_load()
    # img1 = np.array(input_data[0]).astype('float32')
    # img2 = np.array(label_data[0]).astype('float32')
    # print(get_psnr(img1, img2))
    # data_load_test()

    # make_image_set(100, 32, 2)
    # bicubic_test()
    # crop_test()
    # model = train()

    model = load_model('my_model.h5')
    input_data, label_data = data_load_test()

    #predict
    test_index = 10
    result_data_tmp = model.predict(input_data[test_index].reshape(1, 32, 32, 1))
    result_data = np.round(result_data_tmp.reshape(32, 32))
    # print(result_data)

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 3, 1)
    ax2 = fig.add_subplot(1, 3, 2)
    ax3 = fig.add_subplot(1, 3, 3)
    ax1.imshow(input_data[test_index], vmin=0, vmax=255, cmap='gray')
    ax1.set_title('input')
    ax2.imshow(result_data, vmin=0, vmax=255, cmap='gray')
    ax2.set_title('output')
    ax3.imshow(label_data[test_index], vmin=0, vmax=255, cmap='gray')
    ax3.set_title('solution')
    plt.show()
    print(np.max(label_data[test_index]))
    print(np.min(label_data[test_index]))
    print(get_psnr_test(result_data, label_data[test_index]))
    # 그래프 표현
    # y_loss = model.history['val_loss']
    # x_len = np.arange(len(y_loss))
    # plt.plot(x_len, get_psnr(y_loss), "o")
    # plt.show()

    # test()