within Buildings.Fluids.HeatExchangers.CoolingTowers.BaseClasses;
partial model PartialStaticTwoPortCoolingTower
  "Cooling tower with variable speed"
  extends Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,5},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,70},{-68,32}},
          lineColor={0,0,127},
          textString="TAir")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                  graphics));
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TWatIn_degC(
                                                  start=35)
    "Water inlet temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TWatOut_degC(
                                                   start=28)
    "Water outlet temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TAirIn_degC(
                                                  start=25)
    "Air dry-bulb inlet temperature";
  Modelica.Blocks.Interfaces.RealInput TAir
    "Entering air dry or wet bulb temperature" 
                                         annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}, rotation=0)));
equation
  TWatIn_degC  = Modelica.SIunits.Conversions.to_degC(Medium.temperature(sta_a));
  TWatOut_degC = Modelica.SIunits.Conversions.to_degC(Medium.temperature(sta_b));
  TAirIn_degC  = Modelica.SIunits.Conversions.to_degC(TAir);

  dp = 0;
  mXi_flow = zeros(Medium.nXi); // no mass added or removed (sensible heat only)

end PartialStaticTwoPortCoolingTower;
