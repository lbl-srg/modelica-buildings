within Buildings.Fluid.HeatPumps;
model ScrollWaterToWater
  "Model for a scroll water to water heat pump"

  extends Buildings.Fluid.Chillers.BaseClasses.PartialWaterToWater(
    redeclare Chillers.Compressors.ScrollCompressor com(
      redeclare package ref = ref,
      volRat=volRat,
      V_flow_nominal=V_flow_nominal,
      leaCoe=leaCoe,
      etaEle=etaEle,
      PLos=PLos,
      dTSup=dTSup,
      enable_variable_speed=enable_variable_speed));

  parameter Real volRat(min = 1.0, unit = "1")
    "Built-in volume ratio";

  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal(min=0)
    "Refrigerant volume flow rate at suction";

  parameter Modelica.SIunits.MassFlowRate leaCoe(min = 0)
    "Leakage coefficient";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})),
              defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Model for a water to water heat pump with a scroll compressor, as detailed 
in Jin (2002).
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;
