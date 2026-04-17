function get_wire_diameter(I::Float64)
    # 根据最大电流判断导线线径 (单位: mm)
    if 0 < I <= 1.0
        return 0.46
    elseif 1.0 < I <= 2.0
        return 0.56
    elseif 2.0 < I <= 3.0
        return 0.68
    elseif 3.0 < I <= 4.0
        return 0.77
    elseif 4.0 < I <= 5.0
        return 0.785
    else
        return sqrt(4 * I / (5 * pi))
    end
end

function calculate_inductance(D_ave_mm, h_mm, c_mm, N)
    # 采用Wheeler多层线圈电感经验公式进行计算
    D_ave_cm = D_ave_mm / 10.0
    h_cm = h_mm / 10.0
    c_cm = c_mm / 10.0
    
    L_uH = (0.08 * D_ave_cm^2 * N^2) / (3 * D_ave_cm + 9 * h_cm + 10 * c_cm)
    return L_uH / 1000.0 # 转换为mH
end

function design_solenoid()
    # 输入设计参数
    I_max = 3.0           # 最大电流 (A)
    L_rated = 20.0        # 额定电感 (mH)
    h = 85.0              # 电感线圈期望高度 (mm)
    tolerance = 0.5       # 允许偏差 (mH)
    n_layers = 5          # 线圈层数

    # 计算导线线径
    d = get_wire_diameter(I_max)

    # 计算每层平均匝数和总匝数
    K_w = 1.05 # 绕线系数
    N_layer = round(h / (d * K_w))
    N_total = n_layers * N_layer

    # 线圈厚度
    c = n_layers * d * K_w 

    # 初始化内径迭代 
    D_in = 10.0 
    L_calc = 0.0
    iter = 0
    max_iters = 10000 # 循环迭代最大次数

    # 迭代计算 
    while iter <= max_iters
        D_ave = D_in + c
        L_calc = calculate_inductance(D_ave, h, c, N_total)

        if abs(L_calc - L_rated) <= tolerance
            break # 满足条件，跳出循环
        end

        # 根据误差调整内径 
        if L_calc > L_rated
            D_in -= 0.05
        else
            D_in += 0.05
        end
        
        iter += 1
    end

    # 判断并输出结果
    if iter > max_iters
        println("循环迭代10000次后，仍不能满足条件，请重新输入参数！")
    else
        # 铜导线长度
        len_wire = N_total * pi * D_ave 
        
        # 线圈电阻值
        rho = 0.00001851 # 电阻率
        S = pi * (d / 2)^2 # 导线截面积 
        R_coil = rho * len_wire / S

        println("=== 螺线管线圈设计成功 ===")
        println("线圈层数: ", n_layers)
        println("导线线径 (mm): ", d)
        println("线圈内径 (mm): ", round(D_in, digits=2))
        println("线圈匝数 (匝): ", N_total)
        println("最终电感值 (mH): ", round(L_calc, digits=3))
        println("铜导线长度 (mm): ", round(len_wire, digits=2))
        println("线圈电阻值 (Ω): ", round(R_coil, digits=4))
        println("迭代次数: ", iter)
    end
end

design_solenoid()