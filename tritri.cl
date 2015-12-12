__kernel void tri_tri_collide(__global float3* V_in, __global float3* U_in, __global int* c_out) {
    uint addr_V, addr_U, addr_out_v, addr_out_u;

    float3 V0, V1, V2,
           U0, U1, U2;

    float3 VE0, VE1, VE2,
           UE0, UE1, UE2;

    float3 Vnormal, Unormal;

    float3 seg0, seg1, seg2, seg3;

    float3 dir, avg;

    float d0, d1, d2;

    float p00, p01, p10, p11;
    float p0max, p0min, p1max, p1min;

    int pos, neg, zer;

    addr_V = get_global_id(0) * 3;
    addr_U = get_global_id(1) * 3;
//    addr_out = get_global_id(0) * get_global_size(0) + get_global_id(1);
    addr_out_v = get_global_id(0);
    addr_out_u = get_global_id(1) + get_global_size(0);

    V0 = V_in[addr_V];
    V1 = V_in[addr_V + 1];
    V2 = V_in[addr_V + 2];
    
    U0 = U_in[addr_U];
    
    U1 = U_in[addr_U + 1];
    U2 = U_in[addr_U + 2];

    UE1 = U1 - V0;
    UE2 = U2 - V0;

    Unormal = cross(UE1, UE2);

    d0 = dot(Unormal, V0 - U0);
    d1 = dot(Unormal, V1 - U0);
    d2 = dot(Unormal, V2 - U0);

    pos = 0;
    neg = 0;
    zer = 0;

    if (d0 > 0) pos++;
    else if (d0 < 0) neg++;
    else zer++;

    if (d1 > 0) pos++;
    else if (d1 < 0) neg++;
    else zer++;

    if (d2 > 0) pos++;
    else if (d2 < 0) neg++;
    else zer++;

    if (pos > 0 && neg > 0) {
        if (pos == 2) {
            if (d0 < 0.0) {
                seg0 = (d1 * V0 - d0 * V1) / (d1 - d0);
                seg1 = (d2 * V0 - d0 * V2) / (d2 - d0);
            } else if (d1 < 0.0) {
                seg0 = (d0 * V1 - d1 * V0) / (d0 - d1);
                seg1 = (d2 * V1 - d1 * V2) / (d2 - d1);
            } else {
                seg0 = (d0 * V2 - d2 * V0) / (d0 - d2);
                seg1 = (d1 * V2 - d2 * V1) / (d1 - d2);
            }
        } else if (neg == 2) {
            if (d0 > 0.0) {
                seg0 = (d1 * V0 - d0 * V1) / (d1 - d0);
                seg1 = (d2 * V0 - d0 * V2) / (d2 - d0);
            } else if (d1 > 0.0) {
                seg0 = (d0 * V1 - d1 * V0) / (d0 - d1);
                seg1 = (d2 * V1 - d1 * V2) / (d2 - d1);
            } else {
                seg0 = (d0 * V2 - d2 * V0) / (d0 - d2);
                seg1 = (d1 * V2 - d2 * V1) / (d1 - d2);
            }            
        } else {
            if (d0 == 0.0) {
                seg0 = V0;
                seg1 = (d2 * V1 - d1 * V2) / (d2 - d1);
            } else if (d1 == 0.0) {
                seg0 = V1;
                seg1 = (d0 * V2 - d2 * V0) / (d0 - d2);
            } else {
                seg0 = V2;
                seg1 = (d1 * V0 - d0 * V1) / (d1 - d0);
            }
        }
    } else {
        //c_out[addr_out] = 0;
        return;
    }
   
    VE1 = V1 - V0;
    VE2 = V2 - V0;
 
    Vnormal = cross(VE1, VE2);

    pos = 0;
    neg = 0;
    zer = 0;

    d0 = dot(Vnormal, U0 - V0);
    d1 = dot(Vnormal, U1 - V0);
    d2 = dot(Vnormal, U2 - V0);

    if (d0 > 0) pos++;
    else if (d0 < 0) neg++;
    else zer++;

    if (d1 > 0) pos++;
    else if (d1 < 0) neg++;
    else zer++;

    if (d2 > 0) pos++;
    else if (d2 < 0) neg++;
    else zer++;

    if (pos > 0 && neg > 0) {
        if (pos == 2) {
            if (d0 < 0.0) {
                seg2 = (d1 * U0 - d0 * U1) / (d1 - d0);
                seg3 = (d2 * U0 - d0 * U2) / (d2 - d0);
            } else if (d1 < 0.0) {
                seg2 = (d0 * U1 - d1 * U0) / (d0 - d1);
                seg3 = (d2 * U1 - d1 * U2) / (d2 - d1);
            } else {
                seg2 = (d0 * U2 - d2 * U0) / (d0 - d2);
                seg3 = (d1 * U2 - d2 * U1) / (d1 - d2);
            }
        } else if (neg == 2) {
            if (d0 > 0.0) {
                seg2 = (d1 * U0 - d0 * U1) / (d1 - d0);
                seg3 = (d2 * U0 - d0 * U2) / (d2 - d0);
            } else if (d1 > 0.0) {
                seg2 = (d0 * U1 - d1 * U0) / (d0 - d1);
                seg3 = (d2 * U1 - d1 * U2) / (d2 - d1);
            } else {
                seg2 = (d0 * U2 - d2 * U0) / (d0 - d2);
                seg3 = (d1 * U2 - d2 * U1) / (d1 - d2);
            }            
        } else {
            if (d0 == 0.0) {
                seg2 = U0;
                seg3 = (d2 * U1 - d1 * U2) / (d2 - d1);
            } else if (d1 == 0.0) {
                seg2 = U1;
                seg3 = (d0 * U2 - d2 * U0) / (d0 - d2);
            } else {
                seg2 = U2;
                seg3 = (d1 * U0 - d0 * U1) / (d1 - d0);
            }
        }
    } else {
        //c_out[addr_out] = 0;
        return;
    }

    dir = cross(Unormal, Vnormal);
    avg = 0.25f * (seg0 + seg1 + seg2 + seg3);

    p00 = dot(dir, seg0 - avg);
    p01 = dot(dir, seg1 - avg);
    p10 = dot(dir, seg2 - avg);
    p11 = dot(dir, seg3 - avg);

    p0max = max(p00, p01);
    p0min = min(p00, p01);
    p1max = max(p10, p11);
    p1min = min(p10, p11);

    if (p0max > p1min && p0min < p1max) {
        c_out[addr_out_v] = 1;
        c_out[addr_out_u] = 1;
    } else {
        //c_out[addr_out] = 0;
    }
}
