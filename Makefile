###########################################################
## USER SPECIFIC DIRECTORIES ##
###########################################################

# CUDA directory:
CUDA_ROOT_DIR=/usr/local/cuda

###########################################################
## CC COMPILER OPTIONS ##
###########################################################

# CC compiler options:
CC=g++
CC_FLAGS=
CC_LIBS=

###########################################################
## NVCC COMPILER OPTIONS ##
###########################################################

# NVCC compiler options:
NVCC=nvcc
NVCC_FLAGS=
NVCC_LIBS=

# CUDA library directory:
CUDA_LIB_DIR= -L$(CUDA_ROOT_DIR)/lib64
# CUDA include directory:
CUDA_INC_DIR= -I$(CUDA_ROOT_DIR)/include
# CUDA linking libraries:
CUDA_LINK_LIBS= -lcudart

###########################################################
## Project file structure ##
###########################################################

# Source file directory:
SRC_DIR = src

# Object file directory:
OBJ_DIR = build

# Include header file directory:
INC_DIR = include

###########################################################
## Make variables ##
###########################################################

# Target executable name in the bin directory:
EXE = $(OBJ_DIR)/run_test

# Object files:
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/cuda_kernel.o

###########################################################
## Compile and Build Rules ##
###########################################################

# Link C++ and CUDA compiled object files to create the target executable.
# The order-only prerequisite "| $(OBJ_DIR)" ensures the bin directory is created first.
$(EXE): $(OBJS) | $(OBJ_DIR)
	$(CC) $(CC_FLAGS) $(OBJS) -o $@ $(CUDA_INC_DIR) $(CUDA_LIB_DIR) $(CUDA_LINK_LIBS)

# Compile a main .cpp file to an object file.
$(OBJ_DIR)/%.o : %.cpp | $(OBJ_DIR)
	$(CC) $(CC_FLAGS) -c $< -o $@

# Compile other C++ source files from SRC_DIR to object files.
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cpp $(INC_DIR)/%.h | $(OBJ_DIR)
	$(CC) $(CC_FLAGS) -c $< -o $@

# Compile CUDA source files to object files.
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cu $(INC_DIR)/%.cuh | $(OBJ_DIR)
	$(NVCC) $(NVCC_FLAGS) -c $< -o $@ $(NVCC_LIBS)

###########################################################
## Ensure the bin directory exists ##
###########################################################

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

###########################################################
## Run Command ##
###########################################################

# Build the executable and run it.
run: $(EXE)
	./$(EXE)

###########################################################
## Clean ##
###########################################################

# Clean objects and the executable.
clean:
	$(RM) -rf $(OBJ_DIR)
