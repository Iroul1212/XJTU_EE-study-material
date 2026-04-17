include("MainDesign.jl")

function alternative_optimal_layer_search()
    I_max = 3.0
    L_rated = 20.0
    h = 85.0
    tolerance = 0.5
    d = get_wire_diameter(I_max)
    K_w = 1.05
    
    # 选定一个合理的初始内径为基准
    fixed_D_in = 30.0 
    
    best_n_layers = 1
    min_diff = Inf
    
    # 从1层开始叠加，计算哪一层的电感最接近20mH
    for n_layers in 1:10
        N_layer = round(h / (d * K_w))
        N_total = n_layers * N_layer
        c = n_layers * d * K_w
        D_ave = fixed_D_in + c
        
        L_temp = calculate_inductance(D_ave, h, c, N_total)
        diff = abs(L_temp - L_rated)
        
        println("当前", n_layers, " 层, 当前电感: ", round(L_temp, digits=2), " mH")
        
        if diff < min_diff
            min_diff = diff
            best_n_layers = n_layers
        end
    end
    
    println("锁定最优层数为: ", best_n_layers)

    # 在最优层数的基础上不断调整内径，直至符合设计精度
    N_layer = round(h / (d * K_w))
    N_total = best_n_layers * N_layer
    c = best_n_layers * d * K_w 
    
    D_in = fixed_D_in 
    L_calc = 0.0
    iter = 0
    max_iters = 10000

    while iter <= max_iters
        D_ave = D_in + c
        L_calc = calculate_inductance(D_ave, h, c, N_total)

        if abs(L_calc - L_rated) <= tolerance
            break
        end

        if L_calc > L_rated
            D_in -= 0.05
        else
            D_in += 0.05
        end
        iter += 1
    end

    # 输出最终结果
    println("=== 最小电阻最优层数结果 ===")
    if iter <= max_iters
        println("微调迭代次数: ", iter)
        println("最终确定的内径 (mm): ", round(D_in, digits=2))
        println("此时的最终电感 (mH): ", round(L_calc, digits=3))
    else
        println("内径微调失败，尝试更换初始基准内径。")
    end
end

alternative_optimal_layer_search()