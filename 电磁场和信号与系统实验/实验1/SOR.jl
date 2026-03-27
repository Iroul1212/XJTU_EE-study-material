using TyPlot

const a = 40          # 槽宽
const b = 20          # 槽高
const h = 1           # 步距
const nx = 41         # x方向节点数
const ny = 21         # y方向节点数
const tol = 1e-3      # 收敛判据

function sor_compute(alpha::Float64)
    V = zeros(Float64, nx, ny)
    V[:, ny] .= 100.0
    
    iter = 0
    max_err = 1.0
 
# 和第一个都一样
   
    while max_err > tol
        max_err = 0.0
        for i in 2:(nx-1)
            for j in 2:(ny-1)
                v_old = V[i, j]
                # 这两排都是超松弛迭代法的公式
                res = (V[i+1, j] + V[i-1, j] + V[i, j+1] + V[i, j-1] - 4.0 * v_old)
                V[i, j] = v_old + (alpha / 4.0) * res
                
                err = abs(V[i, j] - v_old)
                if err > max_err; max_err = err; end
            end
        end
        iter += 1
        if iter > 10000; break; end # 免得迭代次数太多卡死
    end
    return V, iter, max_err
end

# 打印画图让AI写的
test_alphas = [1.4, 1.5, 1.8]
println("--- 表格数据：特定 Alpha 下的迭代次数 ---")
for alpha in test_alphas
    _, iters, _ = sor_compute(alpha)
    println("收敛因子 α = $alpha 时的迭代次数: $iters")
end

alphas_scan = collect(1.40:0.01:1.80)
iters_scan = [Float64(sor_compute(alpha)[2]) for alpha in alphas_scan]
min_iter, min_idx = findmin(iters_scan)
best_alpha = alphas_scan[min_idx]

V_best, iter_best, err_best = sor_compute(best_alpha)
v_10_4 = V_best[Int(10/h)+1, 4+1]

println("\n--- 表格数据：最佳收敛因子分析 ---")
println("最佳收敛因子 α = ", best_alpha)
println("点（10, 4）的电位值 = ", round(v_10_4, digits=4), " V")
println("采用最佳收敛因子时的迭代次数 = ", Int(iter_best))
println("采用最佳收敛因子时的最大误差 = ", err_best)

figure(3)
clf()

plot(alphas_scan, iters_scan, "b-o", markersize=2, linewidth=1.2)
hold("on")
scatter([best_alpha], [min_iter], color="red", zorder=5)

ylim([0, min_iter * 4]) 

grid("on")
title("迭代次数随收敛因子变化的关系曲线。")
xlabel("收敛因子")
ylabel("迭代次数")

text(best_alpha, min_iter + 50, "  Alpha_opt = $best_alpha", color="red")

gcf()

