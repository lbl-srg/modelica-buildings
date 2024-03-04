within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Validation;
model HybridPlantEnable
  "Validates boiler stage status setpoint signal generation for boiler plants"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.HybridPlantEnable hybPlaEna
    "Instance of hybrid plant enable controller"
    annotation (Placement(transformation(extent={{40,-22},{60,22}})));

protected
  CDL.Logical.Pre pre
    "Pre block for routing back enable signal to stage change process completion input signal"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  CDL.Logical.Change cha "Detect changes in primary loop enable signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine THotWatRet(
    final amplitude=7,
    final phase=0,
    final offset=273.15 + 22,
    final freqHz=1/43200) "Hot water return temeprature"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet(
    final k=273.15 + 30)
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSup(
    final k=273.15 + 30)
    "Hot water supply temperature"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow(final k=0.0037
        /6)        "Hot water flow rate"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatRetSec(
    final k=273.15 + 26) "Hot water secondary loop return temperature"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));

  CDL.Continuous.Sources.Sine pumSpeLagPri(
    final amplitude=0.5,
    final phase=3.1415926535898,
    final offset=0.3,
    final freqHz=1/43200) "Lag primary loop pump speed"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  CDL.Continuous.Sources.Constant minCapFirStaLagPri(final k=2400)
    "Minimum capacity of first stage of lag primary loop"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  CDL.Continuous.Sources.Constant VMinFirStaLagPri(final k=0.2*0.0003)
    "Minimum flow setpoint for first stage of lag primary loop"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  CDL.Continuous.Sources.Constant desCapHigStaLeaPri(final k=30000*0.8)
    "Design capacity of highest stage of lead primary loop"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
equation
  connect(THotWatSupSet.y, hybPlaEna.THotWatSupSet) annotation (Line(points={{-28,40},
          {-20,40},{-20,8},{38,8}},                   color={0,0,127}));
  connect(THotWatRet.y, hybPlaEna.THotWatRet) annotation (Line(points={{-28,0},{
          -18,0},{-18,4},{38,4}},               color={0,0,127}));
  connect(VHotWat_flow.y, hybPlaEna.VHotWat_flow) annotation (Line(points={{-28,-40},
          {6,-40},{6,0},{38,0}},                              color={0,0,127}));
  connect(THotWatSup.y, hybPlaEna.THotWatSup) annotation (Line(points={{-78,-20},
          {-12,-20},{-12,-4},{38,-4}},             color={0,0,127}));
  connect(THotWatRet.y, hybPlaEna.THotWatRetLagPri) annotation (Line(points={{-28,0},
          {-18,0},{-18,-8},{38,-8}},              color={0,0,127}));
  connect(THotWatRetSec.y, hybPlaEna.THotWatRetSec) annotation (Line(points={{-28,
          -120},{8,-120},{8,-12},{38,-12}},         color={0,0,127}));
  connect(pumSpeLagPri.y, hybPlaEna.uPumSpeLagPri) annotation (Line(points={{-28,
          120},{32,120},{32,20},{38,20}}, color={0,0,127}));
  connect(minCapFirStaLagPri.y, hybPlaEna.uCapMinLagPri) annotation (Line(
        points={{-28,80},{20,80},{20,16},{38,16}}, color={0,0,127}));
  connect(VMinFirStaLagPri.y, hybPlaEna.VMinSetLagPri_flow) annotation (Line(
        points={{-78,60},{10,60},{10,12},{38,12}}, color={0,0,127}));
  connect(desCapHigStaLeaPri.y, hybPlaEna.uCapHigLeaPri) annotation (Line(
        points={{-78,-100},{20,-100},{20,-16},{38,-16}}, color={0,0,127}));
  connect(pre.y, cha.u)
    annotation (Line(points={{92,0},{98,0}}, color={255,0,255}));
  connect(hybPlaEna.yEnaNexPri, pre.u)
    annotation (Line(points={{62,0},{68,0}}, color={255,0,255}));
  connect(cha.y, hybPlaEna.uStaChaProEnd) annotation (Line(points={{122,0},{130,
          0},{130,-50},{30,-50},{30,-20},{38,-20}}, color={255,0,255}));
annotation (
 experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Validation/HybridPlantEnable.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.HybridPlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.HybridPlantEnable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2024, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end HybridPlantEnable;
