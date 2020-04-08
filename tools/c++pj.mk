#--- PARAMETER -------------------------
# path
TAR     = f265
SRC_DIR = src
OBJ_DIR = obj
INC_DIR = -I $(SRC_DIR)/include
LIB_DIR =
SRCS    = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*/*.cpp)
OBJS    = $(addprefix $(OBJ_DIR)/, $(patsubst %.cpp, %.o, $(notdir $(SRCS))))

# compiler
CC           = g++ -std=c++11
CFLAGS_DBG  = -g -Wall
#CFLAGS_DBG   =
CFLAGS_OTHER = -O0 -static
CFLAGS       = $(CFLAGS_DBG) $(CFLAGS_OTHER)
Q            = @

vpath % $(dir $(SRCS))


#--- MAIN BODY -------------------------
$(TAR): $(OBJS)
	$(Q) $(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ_DIR)/%.o: %.cpp
	$(Q) $(CC) $(CFLAGS) $(INC_DIR) -c $< -o $@

cleanall:
	$(Q) rm -f $(OBJ_DIR)/* $(TAR)
	rm -rf ./dump/*

check:
	ffmpeg -i ./dump/f265.hevc -v 0 ./dump/f265.tmp.yuv
	diff -q ./dump/f265.tmp.yuv ./dump/f265.yuv
	rm -rf ./dump/*

clean:
	rm -rf ./dump/*

.PHONY: clean $(OBJ_DIR)/%.o
