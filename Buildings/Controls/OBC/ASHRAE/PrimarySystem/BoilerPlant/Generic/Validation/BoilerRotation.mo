within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model BoilerRotation "Validates boiler rotation controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerRotation
    boiRot(
    nBoi=nBoi,
    nSta=nSta,
    staMat=[1,1; 1,1; 1,1],
    lagDevMat=[1,2; 1,2; 0,0]) "Boiler rotation controller"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  CDL.Logical.TimerAccumulating accTim[nBoi]
    "Record total service time of boilers"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  CDL.Continuous.Sources.TimeTable timTab(
    table=[0,0; 0.5,1; 20,1; 30,2; 60,3; 90,2; 100,1; 120,0; 125,1; 145,2; 155,3],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Time-table to control plant stage"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Conversions.IntegerToReal intToRea[nSta,nBoi]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  parameter Integer nBoi=2 "Number of boilers in the plant";
  parameter Integer nSta=3 "Number of stages";
  CDL.Logical.Pre pre1[nBoi] "Logical pre block"
    annotation (Placement(transformation(extent={{90,-80},{110,-60}})));
  CDL.Continuous.Product pro1[nSta,nBoi] "Element-wise product"
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));

  final parameter Integer staIndMat[nSta,nBoi] = {i for i in 1:nSta, j in 1:nBoi}
    "Matrix with rows of boiler indices for each stage";

  CDL.Continuous.Sources.Constant con[nSta,nBoi](k=staIndMat)
    "Matrix with rows of stage indices"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  CDL.Conversions.RealToInteger reaToInt "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  CDL.Routing.IntegerReplicator intRep(nout=nSta) "Integer replicator"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  CDL.Routing.IntegerReplicator intRep1[nSta](nout=fill(nBoi, nSta))
    "Integer replicator"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  CDL.Conversions.RealToInteger reaToInt1[nSta,nBoi]
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  CDL.Integers.Equal intEqu[nSta,nBoi]
    "Find boilers to be enabled for current stage"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Conversions.BooleanToReal booToRea[nSta,nBoi]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.MatrixMax matMax(
    rowMax=false,
    nRow=nSta,
    nCol=nBoi) "Find boiler status for each boiler"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  CDL.Continuous.GreaterThreshold greThr[nBoi](t=fill(0.5, nBoi))
    "Check boiler status for each boiler"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(boiRot.yStaMat, intToRea.u)
    annotation (Line(points={{-78,0},{-72,0}}, color={255,127,0}));

  connect(pre1.y, boiRot.uBoi) annotation (Line(points={{112,-70},{116,-70},{
          116,-90},{-110,-90},{-110,0},{-102,0}},
                                         color={255,0,255}));
  connect(intToRea.y, pro1.u2) annotation (Line(points={{-48,0},{-40,0},{-40,-6},
          {-34,-6}}, color={0,0,127}));
  connect(con.y, pro1.u1) annotation (Line(points={{-78,30},{-40,30},{-40,6},{
          -34,6}}, color={0,0,127}));
  connect(timTab.y[1], reaToInt.u)
    annotation (Line(points={{-78,70},{-72,70}}, color={0,0,127}));
  connect(reaToInt.y, intRep.u)
    annotation (Line(points={{-48,70},{-42,70}}, color={255,127,0}));
  connect(intRep.y, intRep1.u)
    annotation (Line(points={{-18,70},{-12,70}}, color={255,127,0}));
  connect(pro1.y, reaToInt1.u)
    annotation (Line(points={{-10,0},{-2,0}}, color={0,0,127}));
  connect(reaToInt1.y, intEqu.u1)
    annotation (Line(points={{22,0},{38,0}}, color={255,127,0}));
  connect(intRep1.y, intEqu.u2) annotation (Line(points={{12,70},{30,70},{30,-8},
          {38,-8}}, color={255,127,0}));
  connect(intEqu.y, booToRea.u) annotation (Line(points={{62,0},{70,0},{70,-20},
          {-90,-20},{-90,-40},{-82,-40}}, color={255,0,255}));
  connect(booToRea.y, matMax.u)
    annotation (Line(points={{-58,-40},{-52,-40}}, color={0,0,127}));
  connect(matMax.y, greThr.u)
    annotation (Line(points={{-28,-40},{-22,-40}}, color={0,0,127}));
  connect(greThr.y, accTim.u)
    annotation (Line(points={{2,-40},{88,-40}}, color={255,0,255}));
  connect(greThr.y, pre1.u) annotation (Line(points={{2,-40},{60,-40},{60,-70},
          {88,-70}}, color={255,0,255}));
annotation (
   experiment(StopTime=100000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Validation/ControllerTwo.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end BoilerRotation;
