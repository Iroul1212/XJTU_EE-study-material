##### 1. 初始设置与几何

- 新建 Maxwell 2D Design
- 在菜单栏 `Maxwell 2D-Solution Type` 中，选择 **Transient (瞬态)**，Geometry Mode 选择 **Cylindrical about Z (绕 Z 轴柱坐标对称)**![image-20260418111440028](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418111440028.png)
- 在`Modeler-Units`中，将单位修改为cm![image-20260418112252806](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418112252806.png)

- **Draw rectangle**绘制矩形
  - **炮弹**：宽度 $0.17 \text{ cm}$（半径），高度 $1.18 \text{ cm}$。
  - **线圈**：宽度 $0.275 \text{ cm}$（即 $(1.75 - 1.2)/2$），高度 $2.3 \text{ cm}$，左下角坐标定位在 $x=0.6 \text{ cm}$（内半径）
  - **关键步骤 (Band)**：在炮弹外部画一个稍大一点的矩形框（包裹住炮弹并在其运动路径上延伸），命名为 `Band`。这在 ANSYS 中用于定义运动边界。
- **Draw Region** 绘制空气域![image-20260418112847345](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418112847345.png)
- 边界设置，将`region`除开z轴的三边设置为**Balloon**，剩余一条边设置为`Symmetry-odd`![image-20260418114010242](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418114010242.png)

##### 2. 材料分配

- 为线圈分配 `copper`
- 为空气和 Band 分配 `air`
- 为炮弹分配 `iron`![image-20260418113043251](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418113043251.png)

##### 3. 设置运动 

- 选中画的 `Band` 

- 右键点击 `Assign Band`。

- 运动类型选择 **Translation**![image-20260418113554027](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418113554027.png)
- 在Data选项卡中，修改Translate Limit![image-20260418141216269](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418141216269.png)

- 在 Mechanical 选项卡中，设置 Initial Velocity 为 0，**Mass (质量)** 填入 `1gram`![image-20260418113542066](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418113542066.png)

##### 4.电路耦合

- 点击线圈，点击`Assign Excitations-Add Winding`，`type`选择`External`以及`Stranded`![image-20260418114752564](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418114752564.png)

- 点击线圈，点击`Assign Excitations-Coil`，设置匝数为77![image-20260418114945528](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418114945528.png)

- 在**Project Manager**点击`Maxwell2DDesign1-Excitations-Winding1-Add Coil`，选中设置的`Rectangle2`

  ![image-20260418115144095](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418115144095.png)![image-20260418115434423](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418115434423.png)

- 点击线圈，点击`Assign Excitation-External Circuit-Edit External Circuit`，点击`create circuit`![image-20260418121117566](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418121117566.png)

- 从`Component Libraries-Passive Elements-Cap:Capacitor`拖入一个电容，点击电容并设置`Properties`，再从`Component Libraries-Passive Elements-Res:Resistor`拖入一个电阻作为损耗电阻![image-20260418120324000](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418120324000.png)

- 再通过`Draw Ground`绘制接地，连接电路，菜单栏点击`Maxwell Circuit-Export Netlist`,命名为Circuit1，保存为 `.sph `![image-20260418164020168](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418164020168.png)

-  回到**Maxwell 2D**，点击线圈，点击`Assign Excitation-External Circuit-Edit External Circuit`，然后点击`Import Circuit Netlist`导入刚才生成的 `.sph` 文件，`Has Inductor in Circuit`显示打勾则表明导入成功![image-20260418121238437](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418121238437.png)
- 右键线圈，选择`Assign Excitation-Set Core Loss`，以及`Assign Excitation-Set Eddy Effects`![image-20260418144549708](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418144549708.png)![image-20260418145631108](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418145631108.png)

##### 5. 仿真设置与求解后处理

- 菜单栏点击 `Maxwell 2D-Analysis Set up-Add Solution Setup`

- Stop time 设置为 `10 ms`，Time step 设置为 `0.01 ms`![image-20260418130010202](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418130010202.png)

- 网格划分

  - 右键点击Band矩形，依次选择 `Mesh Control - Assign -Inside Selection-Length Based`，**取消勾选** `Restrict the number of additional elements`，**勾选** `Restrict Length of Elements`![image-20260418133322444](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418133322444.png)

  - 按住 `Ctrl` 键，同时选中**炮弹**和**线圈**，再次右键点击，依次选择 `Mesh Control - Assign -Inside Selection-Length Based`，同样取消数量限制，勾选长度限制。最大长度也可以先设置为 **0.05 ![image-20260418133758587](C:\Users\lizhen\AppData\Roaming\Typora\typora-user-images\image-20260418133758587.png)cm**

- 运行检查（Validate Check）并 Analyze all

- 求解完成后，选择菜单栏`Maxwell 2D-Results-Create Transient Report-Rectangular Plot`，可以直接绘制出炮弹的速度 (`Speed`)、位移 (`Position`) 随时间变化的曲线，以及线圈中的放电电流波形