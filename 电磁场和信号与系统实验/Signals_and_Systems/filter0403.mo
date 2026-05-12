model filter0403
  annotation(__MWORKS(version="2025b",ContinueSimConfig(SaveContinueFile="false",SaveBeforeStop="false",NumberBeforeStop=1,FixedContinueInterval="false",ContinueIntervalLength=0.01,ContinueTimeVector)),experiment(Algorithm=Dassl,InlineIntegrator=false,InlineStepSize=false,NumberOfIntervals=500,StartTime=0,StopTime=0.01,StoreEventValue=0,Tolerance=0.0001));
  Modelica.Blocks.Sources.Sine sine(f=500,amplitude=15) 
    annotation (Placement(transformation(origin={-150,20},
extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine1(f=1500,amplitude=5) 
    annotation (Placement(transformation(origin={-150,-25},
extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine2(f=2500,amplitude=3) 
    annotation (Placement(transformation(origin={-150,-70},
extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Add3 add3_1 
    annotation (Placement(transformation(origin={-78,-25},
extent={{-10,-10},{10,10}})));
  Filter_ filter_(samplePeriod=1/48000) 
    annotation (Placement(transformation(origin={-28,-25},
extent={{-10,-10},{10,10}})));
equation
  connect(sine.y, add3_1.u1) 
  annotation(Line(origin={-114,2},
points={{-25,18},{-2,18},{-2,-19},{24,-19}},
color={0,0,127}));
  connect(sine1.y, add3_1.u2) 
  annotation(Line(origin={-114,-25},
  points={{-25,0},{24,0}},
  color={0,0,127}));
  connect(add3_1.u3, sine2.y) 
  annotation(Line(origin={-114,-51},
points={{24,18},{0,18},{0,-19},{-25,-19}},
color={0,0,127}));
  connect(filter_.u, add3_1.y) 
  annotation(Line(origin={-53,-25},
  points={{13,0},{-14,0}},
  color={0,0,127}));

end filter0403;