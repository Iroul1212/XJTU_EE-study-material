include("MainDesign.jl")

function find_optimal_layers_for_min_resistance()
    I_max = 3.0
    L_rated = 20.0
    h = 85.0
    tolerance = 0.5
    d = get_wire_diameter(I_max)
    K_w = 1.05

    optimal_layer = 0
    min_resistance = Inf
    best_design = Dict()

    # 遍历1到10层 
    for n_layers in 1:10
        N_layer = round(h / (d * K_w))
        N_total = n_layers * N_layer
        c = n_layers * d * K_w 
        
        D_in = 10.0 
        L_calc = 0.0
        iter = 0
        max_iters = 10000

        # 迭代寻找当前层数下的合理内径
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

        # 如果在约束内找到了结果，计算电阻并比较
        if iter <= max_iters
            D_ave = D_in + c
            len_wire = N_total * pi * D_ave 
            rho = 0.00001851
            S = pi * (d / 2)^2
            R_coil = rho * len_wire / S

            if R_coil < min_resistance
                min_resistance = R_coil
                optimal_layer = n_layers
                best_design = Dict(
                    "D_in" => D_in,
                    "L_calc" => L_calc,
                    "R_coil" => R_coil,
                    "N_total" => N_total
                )
            end
        end
    end

    println("=== 最小电阻最优层数结果 ===")
    if optimal_layer > 0
        println("最优层数: ", optimal_layer)
        println("最小电阻值 (Ω): ", round(best_design["R_coil"], digits=4))
        println("对应线圈内径 (mm): ", round(best_design["D_in"], digits=2))
        println("对应总匝数 (匝): ", best_design["N_total"])
        println("最终电感值 (mH): ", round(best_design["L_calc"], digits=3))
    else
        println("在1-10层中没有找到满足误差要求的设计。")
    end
end

find_optimal_layers_for_min_resistance()