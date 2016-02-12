within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model ModificationFactorHea

  DerivativesCubicSpline Interpolation_TempDiff
    annotation (Placement(transformation(extent={{24,-52},{44,-32}})));
  DerivativesCubicSpline Interpolation_WaterFlow
    annotation (Placement(transformation(extent={{24,14},{44,34}})));
  DerivativesCubicSpline Interpolation_AirFlow
    annotation (Placement(transformation(extent={{24,74},{44,94}})));
  Modelica.Blocks.Interfaces.RealInput WaterTempInlet
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput WaterFlow
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput AirFlow
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Math.Division division2
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));
  Modelica.Blocks.Sources.Constant TempDiff_rated
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Modelica.Blocks.Sources.Constant WaterFlow_rated
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Interfaces.RealInput RoomTemp
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}})));
  Modelica.Blocks.Math.Add add(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-50,-46},{-30,-26}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-10,14},{10,34}})));
  Modelica.Blocks.Math.Division division3
    annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  Modelica.Blocks.Sources.Constant AirFlow_rated
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Math.MultiProduct multiProduct(nu=3)
    annotation (Placement(transformation(extent={{64,-6},{76,6}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(RoomTemp, add.u2) annotation (Line(points={{-120,-88},{-92,-88},{-72,
          -88},{-72,-42},{-52,-42}},      color={0,0,127}));
  connect(WaterTempInlet, add.u1)
    annotation (Line(points={{-120,-30},{-52,-30}}, color={0,0,127}));
  connect(add.y, division2.u1)
    annotation (Line(points={{-29,-36},{-12,-36}}, color={0,0,127}));
  connect(TempDiff_rated.y, division2.u2) annotation (Line(points={{-29,-70},{-22,
          -70},{-22,-48},{-12,-48}}, color={0,0,127}));
  connect(division2.y, Interpolation_TempDiff.u)
    annotation (Line(points={{11,-42},{22,-42}}, color={0,0,127}));
  connect(WaterFlow, division1.u1)
    annotation (Line(points={{-120,30},{-12,30}}, color={0,0,127}));
  connect(WaterFlow_rated.y, division1.u2) annotation (Line(points={{-29,0},{-22,
          0},{-22,18},{-12,18}}, color={0,0,127}));
  connect(AirFlow, division3.u1)
    annotation (Line(points={{-120,90},{-66,90},{-12,90}},
                                                  color={0,0,127}));
  connect(AirFlow_rated.y, division3.u2) annotation (Line(points={{-29,60},{-22,
          60},{-22,78},{-12,78}}, color={0,0,127}));
  connect(division1.y, Interpolation_WaterFlow.u)
    annotation (Line(points={{11,24},{22,24}}, color={0,0,127}));
  connect(division3.y, Interpolation_AirFlow.u)
    annotation (Line(points={{11,84},{22,84}}, color={0,0,127}));
  connect(Interpolation_AirFlow.y, multiProduct.u[1]) annotation (Line(points={
          {45,84},{60,84},{60,2.8},{64,2.8}}, color={0,0,127}));
  connect(Interpolation_WaterFlow.y, multiProduct.u[2]) annotation (Line(points=
         {{45,24},{52,24},{52,4.44089e-016},{64,4.44089e-016}}, color={0,0,127}));
  connect(Interpolation_TempDiff.y, multiProduct.u[3]) annotation (Line(points=
          {{45,-42},{58,-42},{58,-2.8},{64,-2.8}}, color={0,0,127}));
  connect(multiProduct.y, y)
    annotation (Line(points={{77.02,0},{110,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end ModificationFactorHea;
