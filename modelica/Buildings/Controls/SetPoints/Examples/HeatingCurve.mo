within Buildings.Controls.SetPoints.Examples;
model HeatingCurve "Test model for the heating curve"
  Buildings.Controls.SetPoints.HeatingCurve heaCur(
    m=1,
    TSup0=333.15,
    TRet0=313.15,
    TOut0=263.15) 
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp TOut(
    height=40,
    duration=1,
    offset=263.15) 
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Commands(file=
          "Controls/SetPoints/Examples/HeatingCurve.mos" "run"));
  Buildings.Controls.SetPoints.HeatingCurve heaCur1(
    m=1,
    use_TRoo_in=true,
    TSup0=333.15,
    TRet0=313.15,
    TOut0=263.15,
    dTOutHeaBal=15) 
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Step TRoo(
    offset=273.15 + 20,
    startTime=0.5,
    height=-5) "Night set back from 20 to 15 deg C" 
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant TOut2(k=273.15 - 10) 
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(TOut.y, heaCur.TOut) annotation (Line(
      points={{-59,50},{-50,50},{-50,56},{-42,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut2.y, heaCur1.TOut) annotation (Line(
      points={{-59,10},{-50,10},{-50,16},{-42,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, heaCur1.TRoo_in) annotation (Line(
      points={{-59,-30},{-50,-30},{-50,4},{-41.9,4}},
      color={0,0,127},
      smooth=Smooth.None));
end HeatingCurve;
