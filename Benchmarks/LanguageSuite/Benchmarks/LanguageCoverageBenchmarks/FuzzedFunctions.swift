import _Differentiation
import Foundation

// Functions generated via a fuzzer using standard math operators.

@differentiable(reverse)
func fuzzedMath1(_ x0: Float, _ x1: Float, _ x2: Float) -> Float {
    var y = x0;
    let t3 = x0 + x2 + x2;
    let t4 = x1 + t3;
    let t5 = x0 + t3;
    let t6 = t3 - x1;
    let t7 = x1 * t5;
    let t8 = t7 + x1 + x0;
    let t10 = t8 + x0;
    let t11 = t4 * cos(t10 * (180 / Float.pi));
    let t12 = sin(x2 * t8);
    let t13 = t3 * t8 * t4;
    let t14 = t11 - t11;
    let t15 = x1 - t4 - x1;
    let t16 = t8 * sin(t6 * (180 / Float.pi));
    let t17 = t3 * t3;
    let t18 = t11 - x1 - t13;
    let t19 = sin(t10 * t15);
    let t20 = sin(t17 * t14);
    let t22 = t17 * t13;
    let t23 = x2 * t12 * t11;
    let t24 = t13 - t23 - t17 - t22;
    let t25 = t6 - t6;
    let t27 = x1 + x0;
    let t31 = t25 - t19 - t20;
    let t33 = t18 + t19 + x1;
    let t35 = (t3 * t12 - 1);
    let t37 = t15 * cos(t16 * (180 / Float.pi));
    let t41 = sin(t35 * t15);
    let t49 = t31 / (0.001 + t24);
    let t51 = (x2 * t49 - 1);
    let t54 = t8 * sin(t25 * (180 / Float.pi));
    let t64 = t20 * t24 * t25;
    let t72 = t41 * t27 * t33;
    let t78 = t14 - t72 - t54;
    let t86 = t78 + t64;
    let t102 = t37 * t86 * t51;
    let t = t102;
    y += t;
    return y;
}
@differentiable(reverse)
func fuzzedMath2(_ x0: Float, _ x1: Float, _ x2: Float) -> Float {
    var y = x0;
    let t3 = x2 * cos(x2 * (180 / Float.pi));
    let t4 = t3 * x0;
    let t5 = (t4 * t4 - 1);
    let t6 = x2 * x1 * t3;
    let t7 = t4 * cos(x1 * (180 / Float.pi));
    let t8 = x2 * sin(x1 * (180 / Float.pi));
    let t9 = t7 / (0.001 + t3);
    let t10 = x0 * cos(x0 * (180 / Float.pi));
    let t12 = sin(t9 * t8);
    let t13 = t5 * cos(t10 * (180 / Float.pi));
    let t14 = (t7 * t8 - 1);
    let t15 = t10 + t4 + x2;
    let t16 = (t3 * t7 - 1);
    let t17 = (t16 * t4 - 1);
    let t18 = t5 + t3 + t16;
    let t19 = t4 + t16;
    let t22 = t3 + t19 + t6;
    let t23 = t22 / (0.001 + t22);
    let t24 = t15 * cos(x0 * (180 / Float.pi));
    let t26 = sin(t8 * t15);
    let t27 = t26 - x1;
    let t31 = t7 * sin(t12 * (180 / Float.pi));
    let t32 = t7 - t22 - t26 - t23;
    let t33 = t16 * cos(t3 * (180 / Float.pi));
    let t35 = t15 - t14 - t33;
    let t36 = t8 + x0 + x1;
    let t39 = t6 / (0.001 + t6);
    let t40 = t27 * cos(t8 * (180 / Float.pi));
    let t41 = t16 / (0.001 + t35);
    let t46 = (t17 * t32 - 1);
    let t50 = t18 + t41 + t46;
    let t52 = x2 + t39;
    let t54 = t40 * t4 * t31;
    let t61 = t36 / (0.001 + t52);
    let t64 = t50 * cos(t24 * (180 / Float.pi));
    let t74 = t14 + t13 + t54;
    let t90 = t74 - t61 - t10;
    let t98 = t90 / (0.001 + t64);
    let t102 = t98 / (0.001 + t9);
    let t = t102;
    y += t;
    return y;
}


// Functions generated via a fuzzer incorporating a ternary operator.

@differentiable(reverse)
func fuzzedMathTernary1(_ x0: Float, _ x1: Float, _ x2: Float) -> Float {
    var y = x0;
    let t3 = x1 + x1 + x1;
    let t4 = x1 * x1 * x0;
    let t5 = x0 - x2 - t4;
    let t6 = (t4 + t3) / (t4 - t3 + 0.001);
    let t7 = x2 + x0 + t5;
    let t9 = (x1 * t7 - 1);
    let t10 = sin(t4) * sin(t6);
    let t11 = sin(t6) * sin(t6);
    let t12 = cos(t9) * cos(t6);
    let t15 = t12 / (0.001 + x1);
    let t16 = x0 * t7 * x1;
    let t17 = t6 / (0.001 + x1);
    let t18 = sin(t10) * sin(t4);
    let t19 = (t11 + t16) / (t11 - t16 + 0.001);
    let t22 = (t11 * t11 - 1);
    let t23 = (x1 * t10 - 1);
    let t25 = t17 < t23 ? t17 : t23;
    let t26 = t16 / (0.001 + t12);
    let t28 = t26 / (0.001 + t16);
    let t30 = t28 * sin(t23 * (180 / Float.pi));
    let t31 = t28 * t18 * t19;
    let t33 = t18 + t28 + t5 + t31 + t15;
    let t41 = (t33 + t6) / (t33 - t6 + 0.001);
    let t42 = t7 * t6 * t30;
    let t43 = t16 < t18 ? t16 : t18;
    let t59 = cos(t12) * cos(t25);
    let t81 = t42 + t59 + t22 + t43 + t41;
    let t102 = t81 + t33 + t11;
    let t = t102;
    y += t;
    return y;
}

@differentiable(reverse)
func fuzzedMathTernary2(_ x0: Float, _ x1: Float, _ x2: Float) -> Float {
    var y = x0;
    let t3 = x2 * x1;
    let t4 = t3 / (0.001 + t3);
    let t5 = x2 + t3 + x0;
    let t6 = t4 - t3;
    let t8 = x1 * sin(x1 * (180 / Float.pi));
    let t9 = t5 * sin(x2 * (180 / Float.pi));
    let t10 = t8 - t6 - t9;
    let t11 = t6 * t8;
    let t12 = (t10 + t4) / (t10 - t4 + 0.001);
    let t13 = x2 * t12;
    let t14 = t6 / (0.001 + t11);
    let t15 = t8 - x1 - x2;
    let t18 = sin(x2) * sin(t14);
    let t19 = t12 < t6 ? t12 : t6;
    let t20 = t4 * x0;
    let t21 = (t14 + t8) / (t14 - t8 + 0.001);
    let t22 = (t6 + x1) / (t6 - x1 + 0.001);
    let t23 = sin(x1 * t5);
    let t25 = t18 * t20 * t13;
    let t31 = t21 - t6 - t19 - t23;
    let t34 = t15 - t31 - t13 - t25;
    let t49 = t5 > t22 ? t5 : t22;
    let t102 = (t34 * t49 - 1);
    let t = t102;
    y += t;
    return y;
}
