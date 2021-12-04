within IceTank.BaseClasses;
model LMTDs
  "Normalized log mean temperature difference across the ice storage unit"
  parameter Modelica.SIunits.Temperature TFre = 273.15 "Freezing temperature of water or the latent energy storage material";
  parameter Modelica.SIunits.TemperatureDifference dT_nominal = 10
   "Nominal temperature difference";

  Modelica.Blocks.Interfaces.RealInput TIn(unit="K", displayUnit="degC")
    "Inlet temperature" annotation (Placement(transformation(extent={{-140,20},{
            -100,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outlet temperature" annotation (Placement(transformation(extent={{-140,-60},
            {-100,-20}}), iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput lmtd(final quantity="1")
    "Normalized LMTD" annotation (Placement(transformation(extent={{100,-10},{120,
            10}}), iconTransformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.TemperatureDifference deltaT=0.001
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTif_min=1
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTof_min=0.5
    "Small temperature difference, used for regularization";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";

equation

 dTio =  TIn-TOut;
 dTif = TIn-TFre;
 dTof = TOut-TFre;

 //dTif =  Buildings.Utilities.Math.Functions.smoothMax(
 //   x1 = abs(TIn-TFre),
 //   x2 = dTif_min,
 //   deltaX = deltaT/2);//For discharging, this term is >0
 //dTof =  Buildings.Utilities.Math.Functions.smoothMax(
  //  x1 = abs(TOut-TFre),
  //  x2 = dTof_min,
  //  deltaX = deltaT/2);

  lmtd * dT_nominal =
    if dTif*dTof<0 then
      0
    else if (abs(dTif-dTof) > 0.05*max(abs(dTif),abs(dTof))) then
        (dTio)/log(dTif/dTof)
    else if dTif*dTof == 0.0 then
        0.5*(dTif+dTof)
    else
       0.5*(dTif+dTof)*(1-(dTif-dTof)^2/(dTif*dTof)*(
       1 + (dTif-dTof)^2/(dTif*dTof)/2)/12);

  annotation (defaultComponentName = "lmtdSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This subroutine calculates the log mean temperature difference for the detailed ice storage unit. 
The temperature difference is non-dimensionalized using a nominal temperature difference of 10C. 
This value must be used when obtaining the curve fit coefficients.
</p>
</html>"));
end LMTDs;
