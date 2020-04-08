from numpy import *

def readYuvFile(filename,width,height,frame):
    fp = open(filename,'rb')
    uv_width = width//2
    uv_height = height//2

    Y = zeros((frame,height,width),uint8,'C')
    U = zeros((frame,uv_height,uv_width),uint8,'C')
    V = zeros((frame,uv_height,uv_width),uint8,'C')

    for j in range(frame):
        for m in range(height):
            for n in range(width):
                Y[j,m,n] = ord(fp.read(1))

        for m in range(uv_height):
            for n in range(uv_width):
                U[j,m,n] = ord(fp.read(1))

        for m in range(uv_height):
            for n in range(uv_width):
                V[j,m,n] = ord(fp.read(1))

    fp.close()
    return (Y,U,V)

def DmpYuvFile(src, tgt, ctu_num_x, ctu_num_y, width, height, frame):
    # decode yuv dump
    with open('./dump/decode.dat','wt') as f:
        for i in range(frame):
            for m in range(ctu_num_y):
                for n in range(ctu_num_x):
                    print("frame = ", i, file = f)
                    print("ctu_x = ", n, "ctu_y = ", m, file = f)
                    print("channel = y", file = f)
                    for j in range(32):
                        for k in range(32):
                            if(n*32+k < width) and (m*32+j < height):
                                print(tgt[0][i][m*32+j][n*32+k],end=" ", file = f)
                        print("", file = f)

                    print("channel = u", file = f)
                    for j in range(16):
                        for k in range(16):
                            if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                                print(tgt[1][i][m*16+j][n*16+k],end=" ", file = f)
                        print("", file = f)

                    print("channel = v", file = f)
                    for j in range(16):
                        for k in range(16):
                            if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                                print(tgt[2][i][m*16+j][n*16+k],end=" ", file = f)
                        print("", file = f)

    # rec yuv dump
    with open('./dump/rec.dat','wt') as f:
        for i in range(frame):
            for m in range(ctu_num_y):
                for n in range(ctu_num_x):
                    print("frame = ", i, file = f)
                    print("ctu_x = ", n, "ctu_y = ", m, file = f)
                    print("channel = y", file = f)
                    for j in range(32):
                        for k in range(32):
                            if(n*32+k < width) and (m*32+j < height):
                                print(src[0][i][m*32+j][n*32+k],end=" ", file = f)
                        print("", file = f)

                    print("channel = u", file = f)
                    for j in range(16):
                        for k in range(16):
                            if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                                print(src[1][i][m*16+j][n*16+k],end=" ", file = f)
                        print("", file = f)

                    print("channel = v", file = f)
                    for j in range(16):
                        for k in range(16):
                            if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                                print(src[2][i][m*16+j][n*16+k],end=" ", file = f)
                        print("", file = f)
    


def YuvDifCore(src,tgt,width,height,frame):
    for i in range(frame):
        for m in range(ctu_num_y):
            for n in range(ctu_num_x):
                
                for j in range(32):
                    for k in range(32):
                        if(n*32+k < width) and (m*32+j < height):
                            if(src[0][i][m*32+j][n*32+k] != tgt[0][i][m*32+j][n*32+k]):
                                print("frame = ", i, "channel = y", "ctu_x = ", n, "ctu_y = ", m, "sub_pos_x = ", k, "sub_pos_y = ", j)
                                print("rec pixel is", src[0][i][m*32+j][n*32+k], "decode pixel is", tgt[0][i][m*32+j][n*32+k])
                                return

                for j in range(16):
                    for k in range(16):
                        if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                            if(src[1][i][m*16+j][n*16+k] != tgt[1][i][m*16+j][n*16+k]):
                                print("frame = ", i, "channel = u", "ctu_x = ", n, "ctu_y = ", m, "sub_pos_x = ", k, "sub_pos_y = ", j)
                                print("rec pixel is", src[1][i][m*16+j][n*16+k], "decode pixel is", tgt[1][i][m*16+j][n*16+k])
                                return

                for j in range(16):
                    for k in range(16):
                        if(n*16+k < (width//2)) and (m*16+j < (height//2)):
                            if(src[2][i][m*16+j][n*16+k] != tgt[2][i][m*16+j][n*16+k]):
                                print("frame = ", i, "channel = v", "ctu_x = ", n, "ctu_y = ", m, "sub_pos_x = ", k, "sub_pos_y = ", j)
                                print("rec pixel is", src[2][i][m*16+j][n*16+k], "decode pixel is", tgt[2][i][m*16+j][n*16+k])
                                return
    
if __name__=='__main__':
    width = 1920
    height = 1080
    frame = 4
    ctu_num_x = width//32
    ctu_num_y = height//32
    rec = readYuvFile('./dump/f265.yuv', width, height, frame)
    decode = readYuvFile('./dump/f265.tmp.yuv', width, height, frame)
    DmpYuvFile(rec, decode, ctu_num_x, ctu_num_y, width, height, frame)
                
    YuvDifCore(rec, decode, width, height, frame)