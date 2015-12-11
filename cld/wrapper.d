module cld.wrapper;

/* D-style API */

import std.stdio, std.conv;
import cld.bindings;

class CLException : Exception {
    this(string msg) {
        super("CL [generic]: " ~ msg);
    }
}

class CLInitializationException : CLException {
    this(string msg) {
        super("CL [init]: " ~ msg);
    }
}

abstract class HostManager {
    static cl_platform_id[] platforms;
    static cl_device_id[][] devices;

    static cl_device_id chosen_device;

    static private bool get_platforms_and_devices() {
        // get number of platforms
        uint n_platforms;
        if (clGetPlatformIDs(0, null, &n_platforms) != CL_SUCCESS) {
            throw new CLInitializationException("n_platforms");
        }
        if (n_platforms == 0) {
            stderr.writeln("warning: no platforms found");
            return false;
        }
        platforms = new cl_platform_id[](n_platforms);
        if (clGetPlatformIDs(n_platforms, platforms.ptr, null) != CL_SUCCESS) {
            throw new CLInitializationException("get platforms");
        }

        foreach (plat; platforms) {
            cl_device_id[] platform_devices;
            uint n_devices;
            if (clGetDeviceIDs(plat, CL_DEVICE_TYPE_ALL, 0, null, &n_devices) != CL_SUCCESS) {
                //throw new CLInitializationException("get devices");
                stderr.writeln("warning: no devices for platform");
                continue;
            }
            platform_devices = new cl_device_id[](n_devices);
            if (clGetDeviceIDs(plat, CL_DEVICE_TYPE_ALL, n_devices, platform_devices.ptr, null) != CL_SUCCESS) {
                stderr.writeln("warning: no devices for platform");
                continue;
            }
            devices ~= platform_devices;
        }
        return true;
    }

    static public bool initialize(bool verbose) {
        if (!get_platforms_and_devices()) {
            return false;
        }

        if (verbose) {
            foreach (i, plat; platforms) {
                char[512] s;
                if (clGetPlatformInfo(plat, CL_PLATFORM_NAME, 512, s.ptr, null) != CL_SUCCESS) {
                    stderr.writeln("warning: failed to get platform name");
                } else {
                    writeln("PLATFORM_NAME: " ~ text(s.ptr));
                }

                if (clGetPlatformInfo(plat, CL_PLATFORM_VENDOR, 512, s.ptr, null) != CL_SUCCESS) {
                    stderr.writeln("warning: failed to get platform vendor");
                } else {
                    writeln("PLATFORM_VENDOR: " ~ text(s.ptr));
                }

                foreach (dev; devices[i]) {
                    if (clGetDeviceInfo(dev, CL_DEVICE_NAME, 512, s.ptr, null) != CL_SUCCESS) {
                        stderr.writeln("warning: failed to get device name");
                    } else {
                        writeln("DEVICE_NAME: " ~ text(s.ptr));
                    }
                }
            }
        }

        return true;
    }

    static public bool pick_device_by_name(string name) {
        char[512] s;
        foreach (i, plat; platforms) {
            foreach (dev; devices[i]) {
                if (clGetDeviceInfo(dev, CL_DEVICE_NAME, 512, s.ptr, null) != CL_SUCCESS) {
                    stderr.writeln("warning: failed to get device name");
                } else {
                    if (text(s.ptr) == name) {
                        chosen_device = dev;
                        return true;
                    }
                }
            }
        }

        return false;
    }

    static protected cl_context make_context(cl_device_id devr) {
        int err;
        cl_context ctxt = clCreateContext(dev, 1, &dev, null, null, &err);
        if (err != CL_SUCCESS) {
            throw new CLInitializationException("failed to create context");
        }
        return ctxt;
    }
}

class CLProgram {
    cl_program prg;

    this(cl_context ctxt, string source) {
        int err;

        prg = clCreateProgramWithSource(ctxt, 1, source.ptr, source.length, &err);

        if (err != CL_SUCCESS) {
            throw new CLException("failed to create program");
        }

        if (clBuildProgram(prg, 0, null, null, null, null) != CL_SUCCESS) {
            throw new CLException("failed to build program");
        }
    }

    cl_kernel create_kernel(string name) {
        int err;
        cl_kernel kern = clCreateKernel(prg, toStringz(name), &err);
        if (err != CL_SUCCESS) {
            throw new CLException("failed to create kernel " ~ name);
        }

        return kern;
    }
}


