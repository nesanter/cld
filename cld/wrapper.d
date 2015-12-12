module cld.wrapper;

/* D-style API */

import std.stdio, std.conv, std.string;
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

    static cl_platform_id chosen_platform;
    static cl_device_id chosen_device;
    static cl_context chosen_context;

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


    static public void print_chosen_info() {
        char[512] s;
        if (clGetPlatformInfo(chosen_platform, CL_PLATFORM_NAME, 512, s.ptr, null) != CL_SUCCESS) {
            stderr.writeln("warning: failed to get platform name");
        } else {
            writeln("Chosen platform name: " ~ text(s.ptr));
        }

        if (clGetPlatformInfo(chosen_platform, CL_PLATFORM_VENDOR, 512, s.ptr, null) != CL_SUCCESS) {
            stderr.writeln("warning: failed to get platform vendor");
        } else {
            writeln("Chosen platform vendor: " ~ text(s.ptr));
        }

        get_device_info(chosen_device, s, CL_DEVICE_NAME);
        writeln("Chosen device name: " ~ text(s.ptr));

        cl_device_type[1] type;
        get_device_info(chosen_device, type, CL_DEVICE_TYPE);
        if (type[0] == CL_DEVICE_TYPE_GPU) {
            writeln("Chosen device is GPU: yes");
        } else {
            writeln("Chosen device is GPU: no");
        }
    }

    static private void get_device_info(T)(cl_device_id dev, T[] s, cl_device_info param) {
        if (clGetDeviceInfo(dev, param, T.sizeof * s.length , s.ptr, null) != CL_SUCCESS) {
            stderr.writeln("warning: failed to get device info");
        }
    }

    static public bool pick_device_by_name(string name) {
        char[512] s;
        foreach (i, plat; platforms) {
            foreach (dev; devices[i]) {
                if (clGetDeviceInfo(dev, CL_DEVICE_NAME, 512, s.ptr, null) != CL_SUCCESS) {
                    stderr.writeln("warning: failed to get device name");
                } else {
                    if (text(s.ptr) == name) {
                        chosen_platform = plat;
                        chosen_device = dev;
                        return true;
                    }
                }
            }
        }

        return false;
    }

    static public bool pick_device_by_type(bool fall_back_to_cpu) {
        char[512] s;
        cl_device_type type;
        chosen_platform = null;
        chosen_device = null;


        foreach (i, plat; platforms) {
            foreach (dev; devices[i]) {
                if (clGetDeviceInfo(dev, CL_DEVICE_TYPE, cl_device_type.sizeof, &type, null) != CL_SUCCESS) {
                    stderr.writeln("warning: failed to get device info");
                } else {
                    if (type == CL_DEVICE_TYPE_GPU) {
                        chosen_platform = plat;
                        chosen_device = dev;
                        make_context_for_chosen();
                        return true;
                    } else if (fall_back_to_cpu) {
                        chosen_platform = plat;
                        chosen_device = dev;
                    }
                }
            }
        }

        if (chosen_device !is null) {
            stderr.writeln("warning: falling back to CPU device");
            make_context_for_chosen();
            return true;
        }

        return false;
    }

    static protected void make_context_for_chosen() {
        int err;
        ulong[] props = [cast(ulong)CL_CONTEXT_PLATFORM, cast(ulong)chosen_platform, 0];
        cl_context ctxt = clCreateContext(props.ptr, 1, &chosen_device, null, null, &err);
        if (err != CL_SUCCESS) {
            throw new CLInitializationException("failed to create context");
        }
        chosen_context = ctxt;
    }
}

class CLProgram {
    cl_program prg;

    static CLProgram load_from_file(File f) {
        string[] lines;
        foreach (line; f.byLine(KeepTerminator.yes))
            lines ~= to!string(line);

        return new CLProgram(HostManager.chosen_context, lines);
    }

    this(cl_context ctxt, string[] sources) {
        int err;

        const(char) *[] srcptrs;
        ulong[] lens;
        foreach (s; sources) {
            lens ~= s.length;
            srcptrs ~= s.ptr;
        }

        prg = clCreateProgramWithSource(ctxt, cast(uint)sources.length, srcptrs.ptr, lens.ptr, &err);

        if (err != CL_SUCCESS) {

            throw new CLException("failed to create program");
        }

        if (clBuildProgram(prg, 0, null, null, null, null) != CL_SUCCESS) {
            size_t log_size;
            clGetProgramBuildInfo(prg, HostManager.chosen_device, CL_PROGRAM_BUILD_LOG, 
                                  0, null, &log_size);
            auto program_log = new char[](log_size);
            clGetProgramBuildInfo(prg, HostManager.chosen_device, CL_PROGRAM_BUILD_LOG, 
                                  log_size + 1, program_log.ptr, null);
            writeln(text(program_log.ptr));


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
