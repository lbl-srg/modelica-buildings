within Buildings.Fluid.HeatPumps;
model ReciprocatingWaterToWater
  "Model for a reciprocating water to water heat pump"

  extends Buildings.Fluid.HeatPumps.BaseClasses.PartialWaterToWater(
    redeclare HeatPumps.Compressors.ReciprocatingCompressor com(
      redeclare package ref = ref,
      pisDis=pisDis*scaling_factor,
      cleFac=cleFac,
      etaEle=etaEle,
      PLos=PLos*scaling_factor,
      dTSup=dTSup,
      pDro=pDro));

  parameter Modelica.SIunits.VolumeFlowRate pisDis
    "Piston displacement";

  parameter Real cleFac(min = 0, unit = "1")
    "Clearance factor";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.AbsolutePressure pDro
    "Pressure drop at suction and discharge of the compressor";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})),
              defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Model for a water to water heat pump with a reciprocating compressor, as
detailed in Jin (2002).
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
November 14, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReciprocatingWaterToWater;
