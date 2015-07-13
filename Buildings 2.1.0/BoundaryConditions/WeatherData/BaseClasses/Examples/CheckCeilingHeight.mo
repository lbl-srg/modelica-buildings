within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckCeilingHeight "Test model for ceiling height check"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
       "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
public
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckCeilingHeight
    cheCeiHei "Block that constrains the ceiling height"
     annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    "Block that converts time"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(datRea.y[20], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{21,-9.65517},{30,-9.65517},{30,-10},{38,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-59,-10},{-42,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-19,-10},{-2,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that constrains the ceiling height.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckCeilingHeight.mos"
        "Simulate and plot"));
end CheckCeilingHeight;
