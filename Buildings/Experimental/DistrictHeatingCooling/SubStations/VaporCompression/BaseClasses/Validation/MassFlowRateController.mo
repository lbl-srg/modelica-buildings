within Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.Validation;
model MassFlowRateController
  "Model that validates the controller for the mass flow rate"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TColMin = 273.15+8
    "Minimum temperature of district cold water supply";
  parameter Modelica.SIunits.Temperature THotMax = 273.15+18
    "Maximum temperature of district hot water supply";

  parameter Modelica.SIunits.TemperatureDifference dT_nominal = 4
    "Nominal temperature difference over the heat exchanger";

  Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.MassFlowRateController
    conMasChil(
    cp_default=4184,
    consumer=Buildings.Experimental.DistrictHeatingCooling.Types.Consumer.Cooling,
    dT_nominal=dT_nominal,
    TUp_limit=TColMin) "Controller for chiller"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Modelica.Blocks.Sources.Constant QChi_flow(k=dT_nominal*4184)
    "Heat to be added to loop"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Ramp TUpChi(
    duration=1,
    offset=273.15,
    height=25) "Upstream temperature for chiller"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.MassFlowRateController
    conMasHea(
    cp_default=4184,
    consumer=Buildings.Experimental.DistrictHeatingCooling.Types.Consumer.Heating,
    dT_nominal=-dT_nominal,
    TUp_limit=THotMax) "Controller for heat pump"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Sources.Constant QHea_flow(k=-dT_nominal*4184)
    "Heat to be added to loop"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp TUpHea(
    duration=1,
    offset=273.15,
    height=25) "Upstream temperature for heat pump"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(QChi_flow.y, conMasChil.Q_flow) annotation (Line(points={{-39,60},{-26,
          60},{-26,46},{-12,46}}, color={0,0,127}));
  connect(TUpChi.y, conMasChil.TUp) annotation (Line(points={{-39,20},{-26,20},{
          -26,36},{-12,36}}, color={0,0,127}));
  connect(QHea_flow.y, conMasHea.Q_flow) annotation (Line(points={{-39,-30},{-26,
          -30},{-26,-44},{-12,-44}}, color={0,0,127}));
  connect(TUpHea.y, conMasHea.TUp) annotation (Line(points={{-39,-70},{-26,-70},
          {-26,-54},{-12,-54}}, color={0,0,127}));
  annotation(experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/BaseClasses/Validation/MassFlowRateController.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the controller that adjusts the mass flow rate
of the consumer.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end MassFlowRateController;
