**1. 模型初始化建立**

- 打开COMSOL，“新建”选择**模型导向**![](C:\Users\lizhen\Pictures\Screenshots\屏幕截图 2026-04-17 212359.png)

- “空间维度”选择**二维轴对称**。![](C:\Users\lizhen\Pictures\Screenshots\屏幕截图 2026-04-17 212527.png)
- “选择物理场”选择**AC/DC-电磁场-磁场**，**数学-全局常微分和微分代数方程**，**数学-变形网络-旧的变形网络-动网络**![](C:\Users\lizhen\Pictures\Screenshots\屏幕截图 2026-04-17 213756.png)
- “选择研究”选择**瞬态**![](C:\Users\lizhen\Pictures\Screenshots\屏幕截图 2026-04-17 213821.png)

##### 2.几何建立与材料设置

- **绘制几何**：

  - 点击“几何1”，长度单位改为**cm**![](C:\Users\lizhen\Pictures\Screenshots\屏幕截图 2026-04-17 214037.png)

  - 在旋转轴（$r=0$）的右侧绘制矩形。
  - **炮弹**：宽度 $0.17 \text{ cm}$（半径），高度 $1.18 \text{ cm}$。
  - **线圈**：宽度 $0.275 \text{ cm}$（即 $(1.75 - 1.2)/2$），高度 $2.3 \text{ cm}$，左下角坐标定位在 $r=0.6 \text{ cm}$（内半径）
  - **空气域**：绘制一个足够大矩形包裹住线圈和炮弹运动轨迹。
  - 作一条线段，并对空气域进行分割![](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417222620067.png)

- **材料分配**：线圈赋为铜 (**Copper**)；炮弹赋为钢 (**Iron**)；其余区域赋为空气 **(Air**)![image-20260418085953421](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418085953421.png)

**3. 物理场设置**

- **磁场 (mf)**：
  - 右键添加 **线圈 (Coil)**，选择线圈区域。线圈类型选择“均匀多匝”，匝数设为 77。![image-20260417222715644](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417222715644.png)
  - 在炮弹区域右键，添加 **力计算**，将其命名为 `Force_z`，COMSOL 会自动积分计算炮弹受到的 Z 向电磁力。![image-20260417222729291](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417222729291.png)
  - 添加**固体中的安培定律**，选择炮弹区域，并移动至模型树线圈上方![image-20260418110212863](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418110212863.png)
- **电路 (cir)**：
  - 添加一个 **电容器 **，设置电容值为`1000[uF]`，并在初始值中设定电压为 `35 V`，设置“节点 p”为 `1`，“节点 n”为 `0`
  - 添加一个 **外部 I vs. U 1**，并与 `mf` 中的线圈电压耦合，设置“节点 p”为 `1`，“节点 n”为 `0`
  - 在 **磁场 (mf)** 物理场下，找到你定义的 **线圈节点**。在“线圈模型”设置中，将 **线圈激励**从“电流”切换为 **电路 (电流)**![image-20260417222805879](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417222805879.png)
- **全局 ODE 和 DAE (ge)**：
  - 在这里利用牛顿第二定律求解炮弹的位移 $z$ 和速度 $v$。
  - 输入方程式：$m \frac{dv}{dt} = F_z$（在软件中写为 `0.001[kg]*vt -mf.Forcez_Force_z`，1 g = 0.001 kg）。
  - ![image-20260417225516002](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417225516002.png)
  - 输入方程式：$\frac{dz}{dt} = v$（在软件中写为 `zt - v`）。![image-20260417225648535](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417225648535.png)
- **动网格 (ale)**：
  - 对炮弹区域应用“指定位移”，位移量设为刚才定义的变量 $z$。![image-20260417225749590](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417225749590.png)
  - 对空气域应用“自由变形”，以允许网格随着炮弹移动而拉伸和压缩。![image-20260417225737531](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417225737531.png)

**4. 网格与求解**

- **网格划分**：在炮弹和空气的交界面处需要较密的网格，防止运动过程中网格畸变导致计算不收敛。
- **研究步骤**：选择“瞬态”求解器。由于电容放电是毫秒级甚至微秒级的过程，时间步长建议设置为 $1 \times 10^{-5} \text{ s}$ 甚至更小。![image-20260417225906020](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260417225906020.png)

- 结果如下图所示![image-20260418110553246](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418110553246.png)![image-20260418110646131](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418110646131.png)

