model PartialStaticTwoPortCoolingTower "Cooling tower with variable speed" 
  extends Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=10,
          rgbfillColor={95,95,95})),
      Rectangle(extent=[-100,41; -70,38], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[-100,5; 101,-5],  style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Text(
        extent=[-102,70; -68,32],
        style(color=74, rgbcolor={0,0,127}),
        string="TAir")),  Diagram);
  Modelica.SIunits.CelsiusTemperature TWatIn_degC(start=35) 
    "Water inlet temperature";
  Modelica.SIunits.CelsiusTemperature TWatOut_degC(start=28) 
    "Water outlet temperature";
  Modelica.SIunits.CelsiusTemperature TAirIn_degC(start=25) 
    "Air dry-bulb inlet temperature";
  Modelica.Blocks.Interfaces.RealInput TAir(redeclare type SignalType = 
        Modelica.SIunits.Temperature) 
    "Entering air dry or wet bulb temperature" 
                                         annotation (extent=[-140,20; -100,60]);
equation 
  TWatIn_degC  = medium_a.T_degC;
  TWatOut_degC = medium_b.T_degC;
  TAirIn_degC  = Modelica.SIunits.Conversions.to_degC(TAir);
  
  dp = 0;
  mXi_flow = zeros(Medium.nXi); // no mass added or removed (sensible heat only)
  
end PartialStaticTwoPortCoolingTower;
