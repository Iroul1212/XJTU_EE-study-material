using TyPlot

const a = 40          # 矩形槽宽度
const b = 20          # 矩形槽高度
const h = 1           # 步距
const nx = 41         # x方向节点数
const ny = 21         # y方向节点数
const tol = 1e-3      # 最大允许误差

function run_gauss_seidel()

    V = zeros(Float64, nx, ny)   # 初始化为0
    V[:, ny] .= 100.0             # 顶部设为100V
    
    iter = 0        # 迭代次数
    max_err = 1.0   # 初始化最大误差

    while max_err > tol
        max_err = 0.0
        for i in 2:(nx-1)
            for j in 2:(ny-1)
                old_v = V[i, j]
                # 高斯-赛德尔迭代公式
                V[i, j] = 0.25 * (V[i+1, j] + V[i-1, j] + V[i, j+1] + V[i, j-1])
                
                # 计算本次迭代的最大误差
                err = abs(V[i, j] - old_v)
                if err > max_err
                    max_err = err
                end
            end
        end
        iter += 1
    end
    
    println("点(10, 4)的电位值: ", round(V[Int(10/h)+1, 5], digits=4), " V")
    println("迭代次数: ", iter)
    println("最大误差: ", max_err)
    
    figure()
    contour(0:h:a, 0:h:b, V', 20)
    title("矩形槽内等位线")
    xlabel("x (cm)"); ylabel("y (cm)")
end

run_gauss_seidel()
