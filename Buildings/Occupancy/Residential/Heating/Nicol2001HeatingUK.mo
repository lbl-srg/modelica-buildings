within Buildings.Occupancy.Residential.Heating;
model Nicol2001HeatingUK "A model to predict occupants' heating behavior with 
  outdoor temperature"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real A = 5.28 "Parameter defining the logistic relation: Slope";
    parameter Real B = -0.514 "Parameter defining the logistic relation: Intercept";
    parameter Integer seed = 10 "Seed for the random generator";
    parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";
    Real p "The probability of heating is on";
    output Boolean sampleTrigger "True, if sample time instant";
    Modelica.Blocks.Interfaces.RealInput OutdoorTemp(unit="K") "The outdoor 
  temperature"   annotation (Placement(
          transformation(extent={{-140,-40},{-100,0}}), iconTransformation(extent={{-140,-40},{-100,
              0}})));
    Modelica.Blocks.Interfaces.BooleanInput Occu
      "Indoor occupancy, True for occupied, False for unoccupied"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
    Modelica.Blocks.Interfaces.BooleanOutput HeaterState
      "State of Heater, True for on, False for off"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  initial equation
    t0 = time;
  equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      p = Modelica.Math.exp(A+B*(OutdoorTemp-273.15))/(Modelica.Math.exp(A+B*(OutdoorTemp-273.15))+1);
      if Occu == true then
        HeaterState = Occupancy.Utilities.BinaryVariableGeneration(p=p,globalSeed=seed);
      else
        HeaterState = false;
      end if;
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Heater_Tout")}),                           Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
        <h1 class=\"heading\">Model Description</h1>
        <p>The model predicts the state of heater with the outdoor temperature 
        and occupancy.</p>
        <h4>Inputs</h4>
        <p>Outdoor temperature: should be input with the unit of K. </p>
        <p>Occupancy: a boolean variable, true indicates the space is occupied, 
        false indicates the space is unoccupied. </p>
        <h4>Outputs</h4>
        <p>The state of heater: a boolean variable, true indicates the heating 
        is on, false indicates the heating is off.</p>
        <h4>Dynamics</h4>
        <p>When the space is unoccupied, the heater is always off. When the 
        space is occupied, the lower the outdoor temperature is, the higher 
        the chance to turn on the heater.</p>
        <h4>References</h4>
        <p>The model is documented in the paper &quot;Nichol, J., 2001. 
        Characterizing occupant behavior in buildings: towards a stochastic 
        model of occupant use of windows, lights, blinds heaters and fans. In 
        Proceedings of building simulation 01, an IBPSA Conference.&quot;. </p>
        <p>The model parameters are regressed from the field study in the UK in 
        1998 from 3600 naturally ventilated buildings.</p>
        </html>"));
end Nicol2001HeatingUK;
