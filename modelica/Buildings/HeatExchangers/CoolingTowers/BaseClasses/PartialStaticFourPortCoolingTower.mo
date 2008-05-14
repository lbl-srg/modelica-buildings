model PartialStaticFourPortCoolingTower "Cooling tower with variable speed" 
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-100,-55; 101,-65], style(
          pattern=0,
          fillColor=58,
          rgbfillColor={0,127,0})),
      Text(
        extent=[-62,-38; -20,-74],
        string="air",
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1)),
      Text(
        extent=[-64,98; 0,26],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="water")), Diagram);
  Modelica.SIunits.CelsiusTemperature TWatIn_degC(start=35) 
    "Water inlet temperature";
  Modelica.SIunits.CelsiusTemperature TWatOut_degC(start=28) 
    "Water outlet temperature";
  Modelica.SIunits.CelsiusTemperature TAirIn_degC(start=25) 
    "Air dry-bulb inlet temperature";
  Modelica.SIunits.CelsiusTemperature TAirOut_degC(start=30) 
    "Air dry-bulb outlet temperature";
equation 
  TWatIn_degC  = medium_a1.T_degC;
  TWatOut_degC = medium_b1.T_degC;
  TAirIn_degC  = medium_a2.T_degC;
  TAirOut_degC = medium_b2.T_degC;
  
  Q_flow_1 + Q_flow_2 = 0; // no heat losses other than to the air stream
  
  mXi_flow_1 = zeros(Medium_1.nXi); // no mass added or removed (sensible heat only)
  mXi_flow_2 = zeros(Medium_2.nXi); // no mass added or removed (sensible heat only)
  
  dp_1 = 0;
  dp_2 = 0;
  
end PartialStaticFourPortCoolingTower;
