import std.stdio;

import cld.wrapper, cld.bindings;

enum N = 8;
enum DATA_SIZE_A = 1024 * N, DATA_SIZE_B = 1024 * N;
enum const(size_t)[] local_work_dims = [ 8, 8 ];
enum const(size_t)[] global_work_dims = [ DATA_SIZE_A, DATA_SIZE_B ];
enum RESULT_SIZE = DATA_SIZE_A + DATA_SIZE_B;

pragma(msg, RESULT_SIZE);

struct Triangle {
    float ax, ay, az, _aw,
          bx, by, bz, _bw,
          cx, cy, cz, _cw;
}

void main() {
    HostManager.initialize(true);

    HostManager.pick_device_by_type(true);
    HostManager.print_chosen_info();

    int err;

    auto prg = CLProgram.load_from_file(File("tritri.cl", "r"));
    auto krn = prg.create_kernel("tri_tri_collide");

    float[] data_a = new float[](DATA_SIZE_A * 12);
    float[] data_b = new float[](DATA_SIZE_B * 12);

    for (int i= 0 ; i < data_a.length; i += 12) {
        data_a[i..i+12] = [0, 0, 0, 0, 1, 0, 0, 0, 0.5, 1, 0, 0];
    }

    for (int i = 0 ; i < data_b.length; i += 12) {
        data_b[i..i+12] = [0, 0.25, -1, 0, 1, 0.25, -1., 0, 0.5, 0.25, 1, 0];
    }

    int[] result = new int[](RESULT_SIZE);

    auto buf_in_a = clCreateBuffer(HostManager.chosen_context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, data_a.length * data_a[0].sizeof, data_a.ptr, &err);
    if (err != CL_SUCCESS) {
        throw new CLException("failed to create input buffer");
    }

    auto buf_in_b = clCreateBuffer(HostManager.chosen_context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, data_b.length * data_b[0].sizeof, data_b.ptr, &err);
    if (err != CL_SUCCESS) {
        throw new CLException("failed to create input buffer");
    }

    auto buf_out = clCreateBuffer(HostManager.chosen_context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, RESULT_SIZE * result[0].sizeof, result.ptr, &err);
    if (err != CL_SUCCESS) {
        throw new CLException("failed to create output buffer");
    }

    auto cqueue = clCreateCommandQueue(HostManager.chosen_context, HostManager.chosen_device, CL_QUEUE_PROFILING_ENABLE, &err);
    if (err != CL_SUCCESS) {
        throw new CLException("failed to create command queue");
    }

    if (clSetKernelArg(krn, 0, buf_in_a.sizeof, &buf_in_a) != CL_SUCCESS ||
        clSetKernelArg(krn, 1, buf_in_b.sizeof, &buf_in_b) != CL_SUCCESS ||
        clSetKernelArg(krn, 2, buf_out.sizeof, &buf_out) != CL_SUCCESS) {
        throw new CLException("failed setting kernel arguments");
    }

    cl_event ev1;

    assert(global_work_dims.length == local_work_dims.length);
    if (clEnqueueNDRangeKernel(cqueue, krn, global_work_dims.length, null, global_work_dims.ptr, local_work_dims.ptr, 0, null, &ev1) != CL_SUCCESS) {
        throw new CLException("failed to enqueue ND kernel");
    }

    if (clEnqueueReadBuffer(cqueue, buf_out, CL_TRUE, 0, result.length * result[0].sizeof, result.ptr, 1, &ev1, null) != CL_SUCCESS) {
        throw new CLException("failed to enqueue read buffer");
    }

    /*
    float sum = 0.0;
    foreach (v; result) {
        sum += v;
    }
    writeln("sum = ", sum);
    */
    writeln(result);

    ulong queued_time, complete_time;
    if (clGetEventProfilingInfo(ev1, CL_PROFILING_COMMAND_QUEUED, queued_time.sizeof, &queued_time, null) != CL_SUCCESS ||
        clGetEventProfilingInfo(ev1, CL_PROFILING_COMMAND_END, complete_time.sizeof, &complete_time, null) != CL_SUCCESS) {
        writeln("oops");
    }

    writeln("time (ms) = ", (complete_time - queued_time) / (1000 * 1000));

    clReleaseKernel(krn);
    clReleaseMemObject(buf_in_a);
    clReleaseMemObject(buf_in_b);
    clReleaseMemObject(buf_out);
    clReleaseCommandQueue(cqueue);
    clReleaseProgram(prg.prg);
    clReleaseContext(HostManager.chosen_context);

    writeln("done");
}
