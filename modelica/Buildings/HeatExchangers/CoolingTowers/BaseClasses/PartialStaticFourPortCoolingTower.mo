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
  Modelica.SIunits.Temperature TWatIn(start=273.15+35) 
    "Water inlet temperature";
  Modelica.SIunits.Temperature TWatOut(start=273.15+28) 
    "Water outlet temperature";
  Modelica.SIunits.Temperature TAirIn(start=273.15+25) 
    "Air dry-bulb inlet temperature";
  Modelica.SIunits.Temperature TAirOut(start=273.15+30) 
    "Air dry-bulb outlet temperature";
  Modelica.SIunits.Temperature TApp(min=-20, start=2) "Approach temperature";
equation 
  TWatIn  = medium_a1.T;
  TWatOut = medium_b1.T;
  TAirIn  = medium_a2.T;
  TAirOut = medium_b2.T;
  
  Q_flow_1 = 1E-5*((medium_a1.T)-(medium_a2.T)); // for testing only
  Q_flow_1 + Q_flow_2 = 0;
  
  mXi_flow_1 = zeros(Medium_1.nXi); // no mass added or removed (sensible heat only)
  mXi_flow_2 = zeros(Medium_2.nXi); // no mass added or removed (sensible heat only)
  
  dp_1 = 0;
  dp_2 = 0;
  
end PartialStaticFourPortCoolingTower;
