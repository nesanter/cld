module cld.bindings;
/* OpenCL bindings for D */

/* types */
struct _cl_platform_id;
alias _cl_platform_id * cl_platform_id;

struct _cl_device_id;
alias _cl_device_id * cl_device_id;

struct _cl_context;
alias _cl_context * cl_context;

struct _cl_command_queue;
alias _cl_command_queue * cl_command_queue;

struct _cl_mem;
alias _cl_mem * cl_mem;

struct _cl_program;
alias _cl_program * cl_program;

struct _cl_kernel;
alias _cl_kernel * cl_kernel;

struct _cl_event;
alias _cl_event * cl_event;

struct _cl_sampler;
alias _cl_sampler * cl_sampler;

alias uint cl_bool;
alias ulong cl_bitfield;
alias cl_bitfield cl_device_type;
alias uint cl_platform_info;
alias uint cl_device_info;
alias cl_bitfield cl_device_fp_config;
alias uint cl_device_mem_cache_type;
alias uint cl_device_local_mem_type;
alias cl_bitfield cl_device_exec_capabilities;
alias cl_bitfield cl_device_svm_capabilities;
alias cl_bitfield cl_command_queue_properties;
alias size_t cl_device_partition_property;
alias cl_bitfield cl_device_affinity_domain;
alias size_t cl_context_properties;
alias uint cl_context_info;
alias cl_bitfield cl_queue_properties;
alias uint cl_command_queue_info;
alias uint cl_channel_order;
alias uint cl_channel_type;
alias cl_bitfield cl_mem_flags;
alias cl_bitfield cl_svm_mem_flags;
alias uint cl_mem_object_type;
alias uint cl_mem_info;
alias cl_bitfield cl_mem_migration_flags;
alias uint cl_image_info;
alias uint cl_buffer_create_type;
alias uint cl_addressing_mode;
alias uint cl_filter_mode;
alias uint cl_sampler_info;
alias cl_bitfield cl_map_flags;
alias size_t cl_pipe_properties;
alias uint cl_pipe_info;
alias uint cl_program_info;
alias uint cl_program_build_info;
alias uint cl_program_binary_type;
alias int cl_build_status;
alias uint cl_kernel_info;
alias uint cl_kernel_arg_info;
alias uint cl_kernel_arg_address_qualifier;
alias uint cl_kernel_arg_access_qualifier;
alias cl_bitfield cl_kernel_arg_type_qualifier;
alias uint cl_kernel_work_group_info;
alias uint cl_event_info;
alias uint cl_command_type;
alias uint cl_profiling_info;
alias cl_bitfield cl_sampler_properties;
alias uint cl_kernel_exec_info;

struct cl_image_format {
    cl_channel_order image_channel_order;
    cl_channel_type image_channel_data_type;
}

struct cl_image_desc {
    cl_mem_object_type image_type;
    size_t image_width;
    size_t image_height;
    size_t image_depth;
    size_t image_array_size;
    size_t image_row_pitch;
    size_t image_slice_pitch;
    uint num_mip_levels;
    uint num_samples;
    union {
        cl_mem buffer;
        cl_mem mem_object;
    }
}

struct cl_buffer_region {
    size_t origin;
    size_t size;
}

/* API */

extern (C) {

/* Platform */
int clGetPlatformIDs(uint, cl_platform_id *, uint *);
int clGetPlatformInfo(cl_platform_id, cl_platform_info, size_t, void *, size_t *);

/* Device */
int clGetDeviceIDs(cl_platform_id, cl_device_type, uint, cl_device_id *, uint *);
int clGetDeviceInfo(cl_device_id, cl_device_info, size_t, void *, size_t *);
int clCreateSubDevices(cl_device_id, const(cl_device_partition_property) *, uint, cl_device_id *, uint *);
int clRetainDevice(cl_device_id);
int clReleaseDevice(cl_device_id);

/* Context */
cl_context clCreateContext(const(cl_context_properties) *, uint, const(cl_device_id) *, void function(const(char) *, const(void) *, size_t, void *), void *, int *);
cl_context clCreateContextFromType(const(cl_context_properties) *, cl_device_type, void function(const(char) *, const(void) *, size_t, void *), void *, int *);
int clRetainContext(cl_context);
int clReleaseContext(cl_context);
int clGetContextInfo(cl_context, cl_context_info, size_t, void *, size_t *);

/* Command Queue */
cl_command_queue clCreateCommandQueueWithProperties(cl_context, cl_device_id, const(cl_queue_properties) *, int *);
int clRetainCommandQueue(cl_command_queue);
int clReleaesCommandQueue(cl_command_queue);
int clGetCommandQueueInfo(cl_command_queue, cl_command_queue_info, size_t, void *, size_t *);

/* Memory Object */
cl_mem clCreateBuffer(cl_context, cl_mem_flags, size_t, void *, int *);
cl_mem clCreateSubBuffer(cl_mem, cl_mem_flags, cl_buffer_create_type, const(void) *, int *);
cl_mem clCreateImage(cl_context, cl_mem_flags, const(cl_image_format) *, const(cl_image_desc) *, void *, int *);
version (CL_2_0) cl_mem clCreatePipe(cl_context, cl_mem_flags, uint, uint, const(cl_pipe_properties) *, int *);
int clRetainMemObject(cl_mem);
int clReleaseMemObject(cl_mem);
int clGetSupportedImageFormats(cl_context, cl_mem_flags, cl_mem_object_type, uint, cl_image_format *, uint *);
int clGetMemObjectInfo(cl_mem, cl_mem_info, size_t, void *, size_t *);
int clGetImageInfo(cl_mem, cl_image_info, size_t, void *, size_t *);
version (CL_2_0) int clGetPipeInfo(cl_mem, cl_pipe_info, size_t, void *, size_t *);
int clSetMemObjectDestructorCallback(cl_mem, void function(cl_mem, void *), void *);

/* SVM Allocation */
version (CL_2_0) void * clSVMAlloc(cl_context, cl_svm_mem_flags, size_t, uint);
version (CL_2_0) void clSVMFree(cl_context, void *);

/* Sampler */
cl_sampler clCreateSamplerWithProperties(cl_context, const(cl_sampler_properties) *, int *);
int clRetainSampler(cl_sampler);
int clReleaseSampler(cl_sampler);
int clGetSamplerInfo(cl_sampler, cl_sampler_info, size_t, void *, size_t *);

/* Program Object */
cl_program clCreateProgramWithSource(cl_context, uint, const(char) **, const(size_t) *, int *);
cl_program clCreateProgramWithBinary(cl_context, uint, const(cl_device_id) *, const(size_t) *, const(ubyte) **, int *, int *);
cl_program clCreateProgramWithBuildInKernels(cl_context, uint, const(cl_device_id) *, const(char) *, int *);
int clRetainProgram(cl_program);
int clReleaseProgram(cl_program);
int clBuildProgram(cl_program, uint, const(cl_device_id) *, const(char) *, void function(cl_program, void *), void *);
int clCompileProgram(cl_program, uint, const(cl_device_id) *, const(char) *, uint, const(cl_program) *, const(char) **, void function(cl_program, void *), void *);
cl_program clLinkProgram(cl_context, uint, const(cl_device_id) *, const(char) *, uint, const(cl_program) *, void function(cl_program, void *), void *, int *);
int clUnloadPlatformCompiler(cl_platform_id, cl_platform_info, size_t, void *, size_t *);
int clGetProgramBuildInfo(cl_program, cl_device_id, cl_program_build_info, size_t, void *, size_t *);

/* Kernel Object */
cl_kernel clCreateKernel(cl_program, const(char) *, int *);
int clCreateKernelsInProgram(cl_program, uint, cl_kernel *, uint *);
int clRetainKernel(cl_kernel);
int clReleaseKernel(cl_kernel);
int clSetKernelArg(cl_kernel, uint, size_t, const(void) *);
version (CL_2_0) int clSetKernelArgSVMPointer(cl_kernel, int, const(void) *);
version (CL_2_0) int clSetKernelExecInfo(cl_kernel, cl_kernel_exec_info, size_t, const(void) *);
int clGetKernelInfo(cl_kernel, cl_kernel_info, size_t, void *, size_t *);
int clGetKernelWorkGroupInfo(cl_kernel, cl_device_id, cl_kernel_work_group_info, size_t, void *, size_t *);

/* Event Object */
int clWaitForEvents(uint, const(cl_event) *);
int clGetEventinfo(cl_event, cl_event_info, size_t, void *, size_t *);
cl_event clCreateUserEvent(cl_context, int *);
int clRetainEvent(cl_event);
int clReleaseEvent(cl_event);
int clSetUserEventStatus(cl_event, int);
int clSetEventCallback(cl_event, int, void function(cl_event, int, void *), void *);

/* Profiling */
int clGetEventProfilingInfo(cl_event, cl_profiling_info, size_t, void *, size_t *);

/* Flush and Finish */
int clFlush(cl_command_queue);
int clFinish(cl_command_queue);

/* Enqueued Commands */
int clEnqueueReadBuffer(cl_command_queue, cl_mem, cl_bool, size_t, size_t, void *, uint, const(cl_event) *, cl_event *);
int clEnqueueReadBufferRect(cl_command_queue, cl_mem, cl_bool, const(size_t) *, const(size_t) *, size_t, size_t, size_t, size_t, void *, uint, const(cl_event) *);
int clEnqueueWriteBuffer(cl_command_queue, cl_mem, cl_bool, size_t, size_t, const(void) *, uint, const(cl_event) *, cl_event *);
int clEnqueueWriteBufferRect(cl_command_queue, cl_mem, cl_bool, const(size_t) *, const(size_t) *, const(size_t) *, size_t, size_t, size_t, size_t, const(void) *, uint, const(cl_event) *, cl_event *);
int clEnqueueFillBuffer(cl_command_queue, cl_mem, const(void) *, size_t, size_t, size_t, uint, const(cl_event) *, cl_event *);
int clEnqueueCopyBuffer(cl_command_queue, cl_mem, cl_mem, size_t, size_t, size_t, uint, const(cl_event) *, cl_event *);
int clEnqueueCopyBufferRect(cl_command_queue, cl_mem, const(size_t) *, const(size_t) *, const(size_t) *, size_t, size_t, size_t, size_t, uint, const(cl_event) *, cl_event *);
int clEnqueueReadImage(cl_command_queue, cl_mem, cl_bool, const(size_t) *, size_t, size_t, void *, uint, const(cl_event) *, cl_event *);
int clEnqueueWriteImage(cl_command_queue, cl_mem, cl_bool, const(size_t) *, const(size_t) *, size_t, size_t, const(void) *, uint, const(cl_event) *, cl_event *);
int clEnqueueFillImage(cl_command_queue, cl_mem, const(void *), const(size_t) *, const(size_t) *, uint, const(cl_event) *, cl_event *);
int clEnqueueCopyImage(cl_command_queue, cl_mem, cl_mem, const(size_t) *, const(size_t) *, const(size_t) *, uint, const(cl_event) *, cl_event *);
int clEnqueueCopyImageToBuffer(cl_command_queue, cl_mem, cl_mem, const(size_t) *, const(size_t) *, size_t, uint, const(cl_event) *, cl_event *);
int clEnqueueCopyBufferToImage(cl_command_queue, cl_mem, cl_mem, size_t, const(size_t) *, const(size_t) *, uint, const(cl_event) *, cl_event *);
void * cl_enqueueMapBuffer(cl_command_queue, cl_mem, cl_bool, cl_map_flags, size_t, size_t, uint, const(cl_event) *, cl_event *, int *);
void * clEnqueueMapImage(cl_command_queue, cl_mem, cl_bool, cl_map_flags, const(size_t) *, const(size_t) *, size_t *, size_t *, uint, const(cl_event) *, cl_event *, int *);
int clEnqueueUnmapMemObject(cl_command_queue, cl_mem, void *, uint, const(cl_event) *, cl_event *);
int clEnqueueMigrateMemObjects(cl_command_queue, uint, const(cl_mem) *, cl_mem_migration_flags, uint, const(cl_event) *, cl_event *);
int clEnqueueNDRangeKernel(cl_command_queue, cl_kernel, uint, const(size_t) *, const(size_t) *, const(size_t) *, uint, const(cl_event) *, cl_event *);
int clEnqueueNativeKernel(cl_command_queue, void function(void *), void *, size_t, uint, const(cl_mem) *, const(void) **, uint, const(cl_event) *, cl_event *);
int clEnqueueMarkerWithWaitList(cl_command_queue, uint, const(cl_event) *, cl_event *);
version (CL_2_0) int clEnqueueSVMFree(cl_command_queue, uint, void **, void function(cl_command_queue, uint, void **, void *), void *, uint, const(cl_event) *, cl_event *);
version (CL_2_0) int clEnqueueSVMMemcpy(cl_command_queue, cl_bool, void *, const(void) *, size_t, uint, const(cl_event) *, cl_event *);
version (CL_2_0) int clEnqueueSVMMemFill(cl_command_queue, void *, const(void) *, size_t, size_t, uint, const(cl_event) *, cl_event *);
version (CL_2_0) int clEnqueueSVMMap(cl_command_queue, cl_bool, cl_map_flags, void *, size_t, uint, const(cl_event) *, cl_event *);
version (CL_2_0) int clEnqueueSVMUnmap(cl_command_queue, void *, uint, const(cl_event) *, cl_event *);

/* Extension functions */
void * glGetExtensionFunctionAddressForPlatform(cl_platform_id, const(char) *);

/* Deprecated by 2.0 */
version (CL_2_0) {} else cl_command_queue clCreateCommandQueue(cl_context, cl_device_id, cl_command_queue_properties, int *);
version (CL_2_0) {} else cl_sampler clCreateSampler(cl_context, cl_bool, cl_addressing_mode, cl_filter_mode, int *);
version (CL_2_0) {} else int clEnqueueTask(cl_command_queue, cl_kernel, uint, const(cl_event) *, cl_event *);

} /* extern (C) */

/* Constants */
enum CL_SUCCESS =                                   0;
enum CL_DEVICE_NOT_FOUND =                          -1;
enum CL_DEVICE_NOT_AVAILABLE =                      -2;
enum CL_COMPILER_NOT_AVAILABLE =                    -3;
enum CL_MEM_OBJECT_ALLOCATION_FAILURE =             -4;
enum CL_OUT_OF_RESOURCES =                          -5;
enum CL_OUT_OF_HOST_MEMORY =                        -6;
enum CL_PROFILING_INFO_NOT_AVAILABLE =              -7;
enum CL_MEM_COPY_OVERLAP =                          -8;
enum CL_IMAGE_FORMAT_MISMATCH =                     -9;
enum CL_IMAGE_FORMAT_NOT_SUPPORTED =                -10;
enum CL_BUILD_PROGRAM_FAILURE =                     -11;
enum CL_MAP_FAILURE =                               -12;
enum CL_MISALIGNED_SUB_BUFFER_OFFSET =              -13;
enum CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST =  -14;
enum CL_COMPILE_PROGRAM_FAILURE =                   -15;
enum CL_LINKER_NOT_AVAILABLE =                      -16;
enum CL_LINK_PROGRAM_FAILURE =                      -17;
enum CL_DEVICE_PARTITION_FAILED =                   -18;
enum CL_KERNEL_ARG_INFO_NOT_AVAILABLE =             -19;

enum CL_INVALID_VALUE =                             -30;
enum CL_INVALID_DEVICE_TYPE =                       -31;
enum CL_INVALID_PLATFORM =                          -32;
enum CL_INVALID_DEVICE =                            -33;
enum CL_INVALID_CONTEXT =                           -34;
enum CL_INVALID_QUEUE_PROPERTIES =                  -35;
enum CL_INVALID_COMMAND_QUEUE =                     -36;
enum CL_INVALID_HOST_PTR =                          -37;
enum CL_INVALID_MEM_OBJECT =                        -38;
enum CL_INVALID_IMAGE_FORMAT_DESCRIPTOR =           -39;
enum CL_INVALID_IMAGE_SIZE =                        -40;
enum CL_INVALID_SAMPLER =                           -41;
enum CL_INVALID_BINARY =                            -42;
enum CL_INVALID_BUILD_OPTIONS =                     -43;
enum CL_INVALID_PROGRAM =                           -44;
enum CL_INVALID_PROGRAM_EXECUTABLE =                -45;
enum CL_INVALID_KERNEL_NAME =                       -46;
enum CL_INVALID_KERNEL_DEFINITION =                 -47;
enum CL_INVALID_KERNEL =                            -48;
enum CL_INVALID_ARG_INDEX =                         -49;
enum CL_INVALID_ARG_VALUE =                         -50;
enum CL_INVALID_ARG_SIZE =                          -51;
enum CL_INVALID_KERNEL_ARGS =                       -52;
enum CL_INVALID_WORK_DIMENSION =                    -53;
enum CL_INVALID_WORK_GROUP_SIZE =                   -54;
enum CL_INVALID_WORK_ITEM_SIZE =                    -55;
enum CL_INVALID_GLOBAL_OFFSET =                     -56;
enum CL_INVALID_EVENT_WAIT_LIST =                   -57;
enum CL_INVALID_EVENT =                             -58;
enum CL_INVALID_OPERATION =                         -59;
enum CL_INVALID_GL_OBJECT =                         -60;
enum CL_INVALID_BUFFER_SIZE =                       -61;
enum CL_INVALID_MIP_LEVEL =                         -62;
enum CL_INVALID_GLOBAL_WORK_SIZE =                  -63;
enum CL_INVALID_PROPERTY =                          -64;
enum CL_INVALID_IMAGE_DESCRIPTOR =                  -65;
enum CL_INVALID_COMPILER_OPTIONS =                  -66;
enum CL_INVALID_LINKER_OPTIONS =                    -67;
enum CL_INVALID_DEVICE_PARTITION_COUNT =            -68;
enum CL_INVALID_PIPE_SIZE =                         -69;
enum CL_INVALID_DEVICE_QUEUE =                      -70;

/* OpenCL Version */
enum CL_VERSION_1_0 =                               1;
enum CL_VERSION_1_1 =                               1;
enum CL_VERSION_1_2 =                               1;
enum CL_VERSION_2_0 =                               1;

/* cl_bool */
enum CL_FALSE =                                     0;
enum CL_TRUE =                                      1;
enum CL_BLOCKING =                                  CL_TRUE;
enum CL_NON_BLOCKING =                              CL_FALSE;

/* cl_platform_info */
enum CL_PLATFORM_PROFILE =                          0x0900;
enum CL_PLATFORM_VERSION =                          0x0901;
enum CL_PLATFORM_NAME =                             0x0902;
enum CL_PLATFORM_VENDOR =                           0x0903;
enum CL_PLATFORM_EXTENSIONS =                       0x0904;

/* cl_device_type - bitfield */
enum CL_DEVICE_TYPE_DEFAULT =                       (1 << 0);
enum CL_DEVICE_TYPE_CPU =                           (1 << 1);
enum CL_DEVICE_TYPE_GPU =                           (1 << 2);
enum CL_DEVICE_TYPE_ACCELERATOR =                   (1 << 3);
enum CL_DEVICE_TYPE_CUSTOM =                        (1 << 4);
enum CL_DEVICE_TYPE_ALL =                           0xFFFFFFFF;

/* cl_device_info */
enum CL_DEVICE_TYPE =                                   0x1000;
enum CL_DEVICE_VENDOR_ID =                              0x1001;
enum CL_DEVICE_MAX_COMPUTE_UNITS =                      0x1002;
enum CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS =               0x1003;
enum CL_DEVICE_MAX_WORK_GROUP_SIZE =                    0x1004;
enum CL_DEVICE_MAX_WORK_ITEM_SIZES =                    0x1005;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR =            0x1006;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT =           0x1007;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT =             0x1008;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG =            0x1009;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT =           0x100A;
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE =          0x100B;
enum CL_DEVICE_MAX_CLOCK_FREQUENCY =                    0x100C;
enum CL_DEVICE_ADDRESS_BITS =                           0x100D;
enum CL_DEVICE_MAX_READ_IMAGE_ARGS =                    0x100E;
enum CL_DEVICE_MAX_WRITE_IMAGE_ARGS =                   0x100F;
enum CL_DEVICE_MAX_MEM_ALLOC_SIZE =                     0x1010;
enum CL_DEVICE_IMAGE2D_MAX_WIDTH =                      0x1011;
enum CL_DEVICE_IMAGE2D_MAX_HEIGHT =                     0x1012;
enum CL_DEVICE_IMAGE3D_MAX_WIDTH =                      0x1013;
enum CL_DEVICE_IMAGE3D_MAX_HEIGHT =                     0x1014;
enum CL_DEVICE_IMAGE3D_MAX_DEPTH =                      0x1015;
enum CL_DEVICE_IMAGE_SUPPORT =                          0x1016;
enum CL_DEVICE_MAX_PARAMETER_SIZE =                     0x1017;
enum CL_DEVICE_MAX_SAMPLERS =                           0x1018;
enum CL_DEVICE_MEM_BASE_ADDR_ALIGN =                    0x1019;
enum CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE =               0x101A;
enum CL_DEVICE_SINGLE_FP_CONFIG =                       0x101B;
enum CL_DEVICE_GLOBAL_MEM_CACHE_TYPE =                  0x101C;
enum CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE =              0x101D;
enum CL_DEVICE_GLOBAL_MEM_CACHE_SIZE =                  0x101E;
enum CL_DEVICE_GLOBAL_MEM_SIZE =                        0x101F;
enum CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE =               0x1020;
enum CL_DEVICE_MAX_CONSTANT_ARGS =                      0x1021;
enum CL_DEVICE_LOCAL_MEM_TYPE =                         0x1022;
enum CL_DEVICE_LOCAL_MEM_SIZE =                         0x1023;
enum CL_DEVICE_ERROR_CORRECTION_SUPPORT =               0x1024;
enum CL_DEVICE_PROFILING_TIMER_RESOLUTION =             0x1025;
enum CL_DEVICE_ENDIAN_LITTLE =                          0x1026;
enum CL_DEVICE_AVAILABLE =                              0x1027;
enum CL_DEVICE_COMPILER_AVAILABLE =                     0x1028;
enum CL_DEVICE_EXECUTION_CAPABILITIES =                 0x1029;
enum CL_DEVICE_QUEUE_PROPERTIES =                       0x102A    /* deprecated */;
enum CL_DEVICE_QUEUE_ON_HOST_PROPERTIES =               0x102A;
enum CL_DEVICE_NAME =                                   0x102B;
enum CL_DEVICE_VENDOR =                                 0x102C;
enum CL_DRIVER_VERSION =                                0x102D;
enum CL_DEVICE_PROFILE =                                0x102E;
enum CL_DEVICE_VERSION =                                0x102F;
enum CL_DEVICE_EXTENSIONS =                             0x1030;
enum CL_DEVICE_PLATFORM =                               0x1031;
enum CL_DEVICE_DOUBLE_FP_CONFIG =                       0x1032;
/* 0x1033 reserved for CL_DEVICE_HALF_FP_CONFIG */
enum CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF =            0x1034;
enum CL_DEVICE_HOST_UNIFIED_MEMORY =                    0x1035   /* deprecated */;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR =               0x1036;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT =              0x1037;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_INT =                0x1038;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG =               0x1039;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT =              0x103A;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE =             0x103B;
enum CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF =               0x103C;
enum CL_DEVICE_OPENCL_C_VERSION =                       0x103D;
enum CL_DEVICE_LINKER_AVAILABLE =                       0x103E;
enum CL_DEVICE_BUILT_IN_KERNELS =                       0x103F;
enum CL_DEVICE_IMAGE_MAX_BUFFER_SIZE =                  0x1040;
enum CL_DEVICE_IMAGE_MAX_ARRAY_SIZE =                   0x1041;
enum CL_DEVICE_PARENT_DEVICE =                          0x1042;
enum CL_DEVICE_PARTITION_MAX_SUB_DEVICES =              0x1043;
enum CL_DEVICE_PARTITION_PROPERTIES =                   0x1044;
enum CL_DEVICE_PARTITION_AFFINITY_DOMAIN =              0x1045;
enum CL_DEVICE_PARTITION_TYPE =                         0x1046;
enum CL_DEVICE_REFERENCE_COUNT =                        0x1047;
enum CL_DEVICE_PREFERRED_INTEROP_USER_SYNC =            0x1048;
enum CL_DEVICE_PRINTF_BUFFER_SIZE =                     0x1049;
enum CL_DEVICE_IMAGE_PITCH_ALIGNMENT =                  0x104A;
enum CL_DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT =           0x104B;
enum CL_DEVICE_MAX_READ_WRITE_IMAGE_ARGS =              0x104C;
enum CL_DEVICE_MAX_GLOBAL_VARIABLE_SIZE =               0x104D;
enum CL_DEVICE_QUEUE_ON_DEVICE_PROPERTIES =             0x104E;
enum CL_DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE =         0x104F;
enum CL_DEVICE_QUEUE_ON_DEVICE_MAX_SIZE =               0x1050;
enum CL_DEVICE_MAX_ON_DEVICE_QUEUES =                   0x1051;
enum CL_DEVICE_MAX_ON_DEVICE_EVENTS =                   0x1052;
enum CL_DEVICE_SVM_CAPABILITIES =                       0x1053;
enum CL_DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE =   0x1054;
enum CL_DEVICE_MAX_PIPE_ARGS =                          0x1055;
enum CL_DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS =           0x1056;
enum CL_DEVICE_PIPE_MAX_PACKET_SIZE =                   0x1057;
enum CL_DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT =    0x1058;
enum CL_DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT =      0x1059;
enum CL_DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT =       0x105A;

/* cl_device_fp_config - bitfield */
enum CL_FP_DENORM =                                 (1 << 0);
enum CL_FP_INF_NAN =                                (1 << 1);
enum CL_FP_ROUND_TO_NEAREST =                       (1 << 2);
enum CL_FP_ROUND_TO_ZERO =                          (1 << 3);
enum CL_FP_ROUND_TO_INF =                           (1 << 4);
enum CL_FP_FMA =                                    (1 << 5);
enum CL_FP_SOFT_FLOAT =                             (1 << 6);
enum CL_FP_CORRECTLY_ROUNDED_DIVIDE_SQRT =          (1 << 7);

/* cl_device_mem_cache_type */
enum CL_NONE =                                      0x0;
enum CL_READ_ONLY_CACHE =                           0x1;
enum CL_READ_WRITE_CACHE =                          0x2;

/* cl_device_local_mem_type */
enum CL_LOCAL =                                     0x1;
enum CL_GLOBAL =                                    0x2;

/* cl_device_exec_capabilities - bitfield */
enum CL_EXEC_KERNEL =                               (1 << 0);
enum CL_EXEC_NATIVE_KERNEL =                        (1 << 1);

/* cl_command_queue_properties - bitfield */
enum CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE =       (1 << 0);
enum CL_QUEUE_PROFILING_ENABLE =                    (1 << 1);
enum CL_QUEUE_ON_DEVICE =                           (1 << 2);
enum CL_QUEUE_ON_DEVICE_DEFAULT =                   (1 << 3);

/* cl_context_info  */
enum CL_CONTEXT_REFERENCE_COUNT =                   0x1080;
enum CL_CONTEXT_DEVICES =                           0x1081;
enum CL_CONTEXT_PROPERTIES =                        0x1082;
enum CL_CONTEXT_NUM_DEVICES =                       0x1083;

/* cl_context_properties */
enum CL_CONTEXT_PLATFORM =                          0x1084;
enum CL_CONTEXT_INTEROP_USER_SYNC =                 0x1085;
    
/* cl_device_partition_property */
enum CL_DEVICE_PARTITION_EQUALLY =                  0x1086;
enum CL_DEVICE_PARTITION_BY_COUNTS =                0x1087;
enum CL_DEVICE_PARTITION_BY_COUNTS_LIST_END =       0x0;
enum CL_DEVICE_PARTITION_BY_AFFINITY_DOMAIN =       0x1088;
    
/* cl_device_affinity_domain */
enum CL_DEVICE_AFFINITY_DOMAIN_NUMA =                (1 << 0);
enum CL_DEVICE_AFFINITY_DOMAIN_L4_CACHE =            (1 << 1);
enum CL_DEVICE_AFFINITY_DOMAIN_L3_CACHE =            (1 << 2);
enum CL_DEVICE_AFFINITY_DOMAIN_L2_CACHE =            (1 << 3);
enum CL_DEVICE_AFFINITY_DOMAIN_L1_CACHE =            (1 << 4);
enum CL_DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE =  (1 << 5);
    
/* cl_device_svm_capabilities */
enum CL_DEVICE_SVM_COARSE_GRAIN_BUFFER =            (1 << 0);
enum CL_DEVICE_SVM_FINE_GRAIN_BUFFER =              (1 << 1);
enum CL_DEVICE_SVM_FINE_GRAIN_SYSTEM =              (1 << 2);
enum CL_DEVICE_SVM_ATOMICS =                        (1 << 3);

/* cl_command_queue_info */
enum CL_QUEUE_CONTEXT =                             0x1090;
enum CL_QUEUE_DEVICE =                              0x1091;
enum CL_QUEUE_REFERENCE_COUNT =                     0x1092;
enum CL_QUEUE_PROPERTIES =                          0x1093;
enum CL_QUEUE_SIZE =                                0x1094;

/* cl_mem_flags and cl_svm_mem_flags - bitfield */
enum CL_MEM_READ_WRITE =                            (1 << 0);
enum CL_MEM_WRITE_ONLY =                            (1 << 1);
enum CL_MEM_READ_ONLY =                             (1 << 2);
enum CL_MEM_USE_HOST_PTR =                          (1 << 3);
enum CL_MEM_ALLOC_HOST_PTR =                        (1 << 4);
enum CL_MEM_COPY_HOST_PTR =                         (1 << 5);
/* reserved                                         (1 << 6)    */
enum CL_MEM_HOST_WRITE_ONLY =                       (1 << 7);
enum CL_MEM_HOST_READ_ONLY =                        (1 << 8);
enum CL_MEM_HOST_NO_ACCESS =                        (1 << 9);
enum CL_MEM_SVM_FINE_GRAIN_BUFFER =                 (1 << 10)   /* used by cl_svm_mem_flags only */;
enum CL_MEM_SVM_ATOMICS =                           (1 << 11)   /* used by cl_svm_mem_flags only */;
enum CL_MEM_KERNEL_READ_AND_WRITE =                 (1 << 12);

/* cl_mem_migration_flags - bitfield */
enum CL_MIGRATE_MEM_OBJECT_HOST =                   (1 << 0);
enum CL_MIGRATE_MEM_OBJECT_CONTENT_UNDEFINED =      (1 << 1);

/* cl_channel_order */
enum CL_R =                                         0x10B0;
enum CL_A =                                         0x10B1;
enum CL_RG =                                        0x10B2;
enum CL_RA =                                        0x10B3;
enum CL_RGB =                                       0x10B4;
enum CL_RGBA =                                      0x10B5;
enum CL_BGRA =                                      0x10B6;
enum CL_ARGB =                                      0x10B7;
enum CL_INTENSITY =                                 0x10B8;
enum CL_LUMINANCE =                                 0x10B9;
enum CL_Rx =                                        0x10BA;
enum CL_RGx =                                       0x10BB;
enum CL_RGBx =                                      0x10BC;
enum CL_DEPTH =                                     0x10BD;
enum CL_DEPTH_STENCIL =                             0x10BE;
enum CL_sRGB =                                      0x10BF;
enum CL_sRGBx =                                     0x10C0;
enum CL_sRGBA =                                     0x10C1;
enum CL_sBGRA =                                     0x10C2;
enum CL_ABGR =                                      0x10C3;

/* cl_channel_type */
enum CL_SNORM_INT8 =                                0x10D0;
enum CL_SNORM_INT16 =                               0x10D1;
enum CL_UNORM_INT8 =                                0x10D2;
enum CL_UNORM_INT16 =                               0x10D3;
enum CL_UNORM_SHORT_565 =                           0x10D4;
enum CL_UNORM_SHORT_555 =                           0x10D5;
enum CL_UNORM_INT_101010 =                          0x10D6;
enum CL_SIGNED_INT8 =                               0x10D7;
enum CL_SIGNED_INT16 =                              0x10D8;
enum CL_SIGNED_INT32 =                              0x10D9;
enum CL_UNSIGNED_INT8 =                             0x10DA;
enum CL_UNSIGNED_INT16 =                            0x10DB;
enum CL_UNSIGNED_INT32 =                            0x10DC;
enum CL_HALF_FLOAT =                                0x10DD;
enum CL_FLOAT =                                     0x10DE;
enum CL_UNORM_INT24 =                               0x10DF;

/* cl_mem_object_type */
enum CL_MEM_OBJECT_BUFFER =                         0x10F0;
enum CL_MEM_OBJECT_IMAGE2D =                        0x10F1;
enum CL_MEM_OBJECT_IMAGE3D =                        0x10F2;
enum CL_MEM_OBJECT_IMAGE2D_ARRAY =                  0x10F3;
enum CL_MEM_OBJECT_IMAGE1D =                        0x10F4;
enum CL_MEM_OBJECT_IMAGE1D_ARRAY =                  0x10F5;
enum CL_MEM_OBJECT_IMAGE1D_BUFFER =                 0x10F6;
enum CL_MEM_OBJECT_PIPE =                           0x10F7;

/* cl_mem_info */
enum CL_MEM_TYPE =                                  0x1100;
enum CL_MEM_FLAGS =                                 0x1101;
enum CL_MEM_SIZE =                                  0x1102;
enum CL_MEM_HOST_PTR =                              0x1103;
enum CL_MEM_MAP_COUNT =                             0x1104;
enum CL_MEM_REFERENCE_COUNT =                       0x1105;
enum CL_MEM_CONTEXT =                               0x1106;
enum CL_MEM_ASSOCIATED_MEMOBJECT =                  0x1107;
enum CL_MEM_OFFSET =                                0x1108;
enum CL_MEM_USES_SVM_POINTER =                      0x1109;

/* cl_image_info */
enum CL_IMAGE_FORMAT =                              0x1110;
enum CL_IMAGE_ELEMENT_SIZE =                        0x1111;
enum CL_IMAGE_ROW_PITCH =                           0x1112;
enum CL_IMAGE_SLICE_PITCH =                         0x1113;
enum CL_IMAGE_WIDTH =                               0x1114;
enum CL_IMAGE_HEIGHT =                              0x1115;
enum CL_IMAGE_DEPTH =                               0x1116;
enum CL_IMAGE_ARRAY_SIZE =                          0x1117;
enum CL_IMAGE_BUFFER =                              0x1118;
enum CL_IMAGE_NUM_MIP_LEVELS =                      0x1119;
enum CL_IMAGE_NUM_SAMPLES =                         0x111A;
    
/* cl_pipe_info */
enum CL_PIPE_PACKET_SIZE =                          0x1120;
enum CL_PIPE_MAX_PACKETS =                          0x1121;

/* cl_addressing_mode */
enum CL_ADDRESS_NONE =                              0x1130;
enum CL_ADDRESS_CLAMP_TO_EDGE =                     0x1131;
enum CL_ADDRESS_CLAMP =                             0x1132;
enum CL_ADDRESS_REPEAT =                            0x1133;
enum CL_ADDRESS_MIRRORED_REPEAT =                   0x1134;

/* cl_filter_mode */
enum CL_FILTER_NEAREST =                            0x1140;
enum CL_FILTER_LINEAR =                             0x1141;

/* cl_sampler_info */
enum CL_SAMPLER_REFERENCE_COUNT =                   0x1150;
enum CL_SAMPLER_CONTEXT =                           0x1151;
enum CL_SAMPLER_NORMALIZED_COORDS =                 0x1152;
enum CL_SAMPLER_ADDRESSING_MODE =                   0x1153;
enum CL_SAMPLER_FILTER_MODE =                       0x1154;
enum CL_SAMPLER_MIP_FILTER_MODE =                   0x1155;
enum CL_SAMPLER_LOD_MIN =                           0x1156;
enum CL_SAMPLER_LOD_MAX =                           0x1157;

/* cl_map_flags - bitfield */
enum CL_MAP_READ =                                  (1 << 0);
enum CL_MAP_WRITE =                                 (1 << 1);
enum CL_MAP_WRITE_INVALIDATE_REGION =               (1 << 2);

/* cl_program_info */
enum CL_PROGRAM_REFERENCE_COUNT =                   0x1160;
enum CL_PROGRAM_CONTEXT =                           0x1161;
enum CL_PROGRAM_NUM_DEVICES =                       0x1162;
enum CL_PROGRAM_DEVICES =                           0x1163;
enum CL_PROGRAM_SOURCE =                            0x1164;
enum CL_PROGRAM_BINARY_SIZES =                      0x1165;
enum CL_PROGRAM_BINARIES =                          0x1166;
enum CL_PROGRAM_NUM_KERNELS =                       0x1167;
enum CL_PROGRAM_KERNEL_NAMES =                      0x1168;

/* cl_program_build_info */
enum CL_PROGRAM_BUILD_STATUS =                      0x1181;
enum CL_PROGRAM_BUILD_OPTIONS =                     0x1182;
enum CL_PROGRAM_BUILD_LOG =                         0x1183;
enum CL_PROGRAM_BINARY_TYPE =                       0x1184;
enum CL_PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE =  0x1185;
    
/* cl_program_binary_type */
enum CL_PROGRAM_BINARY_TYPE_NONE =                  0x0;
enum CL_PROGRAM_BINARY_TYPE_COMPILED_OBJECT =       0x1;
enum CL_PROGRAM_BINARY_TYPE_LIBRARY =               0x2;
enum CL_PROGRAM_BINARY_TYPE_EXECUTABLE =            0x4;

/* cl_build_status */
enum CL_BUILD_SUCCESS =                             0;
enum CL_BUILD_NONE =                                -1;
enum CL_BUILD_ERROR =                               -2;
enum CL_BUILD_IN_PROGRESS =                         -3;

/* cl_kernel_info */
enum CL_KERNEL_FUNCTION_NAME =                      0x1190;
enum CL_KERNEL_NUM_ARGS =                           0x1191;
enum CL_KERNEL_REFERENCE_COUNT =                    0x1192;
enum CL_KERNEL_CONTEXT =                            0x1193;
enum CL_KERNEL_PROGRAM =                            0x1194;
enum CL_KERNEL_ATTRIBUTES =                         0x1195;

/* cl_kernel_arg_info */
enum CL_KERNEL_ARG_ADDRESS_QUALIFIER =              0x1196;
enum CL_KERNEL_ARG_ACCESS_QUALIFIER =               0x1197;
enum CL_KERNEL_ARG_TYPE_NAME =                      0x1198;
enum CL_KERNEL_ARG_TYPE_QUALIFIER =                 0x1199;
enum CL_KERNEL_ARG_NAME =                           0x119A;

/* cl_kernel_arg_address_qualifier */
enum CL_KERNEL_ARG_ADDRESS_GLOBAL =                 0x119B;
enum CL_KERNEL_ARG_ADDRESS_LOCAL =                  0x119C;
enum CL_KERNEL_ARG_ADDRESS_CONSTANT =               0x119D;
enum CL_KERNEL_ARG_ADDRESS_PRIVATE =                0x119E;

/* cl_kernel_arg_access_qualifier */
enum CL_KERNEL_ARG_ACCESS_READ_ONLY =               0x11A0;
enum CL_KERNEL_ARG_ACCESS_WRITE_ONLY =              0x11A1;
enum CL_KERNEL_ARG_ACCESS_READ_WRITE =              0x11A2;
enum CL_KERNEL_ARG_ACCESS_NONE =                    0x11A3;
    
/* cl_kernel_arg_type_qualifer */
enum CL_KERNEL_ARG_TYPE_NONE =                      0;
enum CL_KERNEL_ARG_TYPE_CONST =                     (1 << 0);
enum CL_KERNEL_ARG_TYPE_RESTRICT =                  (1 << 1);
enum CL_KERNEL_ARG_TYPE_VOLATILE =                  (1 << 2);
enum CL_KERNEL_ARG_TYPE_PIPE =                      (1 << 3);

/* cl_kernel_work_group_info */
enum CL_KERNEL_WORK_GROUP_SIZE =                    0x11B0;
enum CL_KERNEL_COMPILE_WORK_GROUP_SIZE =            0x11B1;
enum CL_KERNEL_LOCAL_MEM_SIZE =                     0x11B2;
enum CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE =  0x11B3;
enum CL_KERNEL_PRIVATE_MEM_SIZE =                   0x11B4;
enum CL_KERNEL_GLOBAL_WORK_SIZE =                   0x11B5;
    
/* cl_kernel_exec_info */
enum CL_KERNEL_EXEC_INFO_SVM_PTRS =                 0x11B6;
enum CL_KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM =    0x11B7;

/* cl_event_info  */
enum CL_EVENT_COMMAND_QUEUE =                       0x11D0;
enum CL_EVENT_COMMAND_TYPE =                        0x11D1;
enum CL_EVENT_REFERENCE_COUNT =                     0x11D2;
enum CL_EVENT_COMMAND_EXECUTION_STATUS =            0x11D3;
enum CL_EVENT_CONTEXT =                             0x11D4;

/* cl_command_type */
enum CL_COMMAND_NDRANGE_KERNEL =                    0x11F0;
enum CL_COMMAND_TASK =                              0x11F1;
enum CL_COMMAND_NATIVE_KERNEL =                     0x11F2;
enum CL_COMMAND_READ_BUFFER =                       0x11F3;
enum CL_COMMAND_WRITE_BUFFER =                      0x11F4;
enum CL_COMMAND_COPY_BUFFER =                       0x11F5;
enum CL_COMMAND_READ_IMAGE =                        0x11F6;
enum CL_COMMAND_WRITE_IMAGE =                       0x11F7;
enum CL_COMMAND_COPY_IMAGE =                        0x11F8;
enum CL_COMMAND_COPY_IMAGE_TO_BUFFER =              0x11F9;
enum CL_COMMAND_COPY_BUFFER_TO_IMAGE =              0x11FA;
enum CL_COMMAND_MAP_BUFFER =                        0x11FB;
enum CL_COMMAND_MAP_IMAGE =                         0x11FC;
enum CL_COMMAND_UNMAP_MEM_OBJECT =                  0x11FD;
enum CL_COMMAND_MARKER =                            0x11FE;
enum CL_COMMAND_ACQUIRE_GL_OBJECTS =                0x11FF;
enum CL_COMMAND_RELEASE_GL_OBJECTS =                0x1200;
enum CL_COMMAND_READ_BUFFER_RECT =                  0x1201;
enum CL_COMMAND_WRITE_BUFFER_RECT =                 0x1202;
enum CL_COMMAND_COPY_BUFFER_RECT =                  0x1203;
enum CL_COMMAND_USER =                              0x1204;
enum CL_COMMAND_BARRIER =                           0x1205;
enum CL_COMMAND_MIGRATE_MEM_OBJECTS =               0x1206;
enum CL_COMMAND_FILL_BUFFER =                       0x1207;
enum CL_COMMAND_FILL_IMAGE =                        0x1208;
enum CL_COMMAND_SVM_FREE =                          0x1209;
enum CL_COMMAND_SVM_MEMCPY =                        0x120A;
enum CL_COMMAND_SVM_MEMFILL =                       0x120B;
enum CL_COMMAND_SVM_MAP =                           0x120C;
enum CL_COMMAND_SVM_UNMAP =                         0x120D;

/* command execution status */
enum CL_COMPLETE =                                  0x0;
enum CL_RUNNING =                                   0x1;
enum CL_SUBMITTED =                                 0x2;
enum CL_QUEUED =                                    0x3;

/* cl_buffer_create_type  */
enum CL_BUFFER_CREATE_TYPE_REGION =                 0x1220;

/* cl_profiling_info  */
enum CL_PROFILING_COMMAND_QUEUED =                  0x1280;
enum CL_PROFILING_COMMAND_SUBMIT =                  0x1281;
enum CL_PROFILING_COMMAND_START =                   0x1282;
enum CL_PROFILING_COMMAND_END =                     0x1283;
enum CL_PROFILING_COMMAND_COMPLETE =                0x1284;

