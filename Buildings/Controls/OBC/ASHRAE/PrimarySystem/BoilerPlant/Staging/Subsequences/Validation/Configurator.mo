within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Validation;
model Configurator "Validate boiler staging configurator subsequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-1"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf1(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-2"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf2(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-3"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf3(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-4"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf4(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-5"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator
    conf5(
    final nSta=5,
    final nBoi=3,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
                  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final staMat={{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}},
    final boiDesCap={100,150,250},
    final boiFirMin={0.4,0.2,0.3})
    "Validation scenario-6"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva[3](
    final k={true,true,true})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva1[3](
    final k={false,true,true})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva3[3](
    final k={true,true,false})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva4[3](
    final k={true,false,false})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva5[3](
    final k={false,false,false})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva2[3](
    final k={false,false,true})
    "Boiler availability array"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(conf.uBoiAva, chiAva.y)
    annotation (Line(points={{18,100},{-18,100}},
      color={255,0,255}));
  connect(chiAva1.y, conf1.uBoiAva)
    annotation (Line(points={{-18,60},{18,60}},
      color={255,0,255}));
  connect(conf2.uBoiAva, chiAva2.y)
    annotation (Line(points={{18,20},{-18,20}},
      color={255,0,255}));
  connect(conf3.uBoiAva, chiAva3.y)
    annotation (Line(points={{18,-20},{-18,-20}},
      color={255,0,255}));
  connect(conf4.uBoiAva, chiAva4.y)
    annotation (Line(points={{18,-60},{-18,-60}},
      color={255,0,255}));
  connect(conf5.uBoiAva, chiAva5.y)
    annotation (Line(points={{18,-100},{-18,-100}},
      color={255,0,255}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Subsequences/Validation/Configurator.mos"
        "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Configurator</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
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
       coordinateSystem(preserveAspectRatio=false, extent={{-60,-120},{60,120}})));
end Configurator;
