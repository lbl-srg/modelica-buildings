within Buildings.HeatTransfer.Conduction.BaseClasses;
block ConductionTransferFunction
  "Block that computes heat conduction using the Conduction Transfer Function Method"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  replaceable parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Construction definition from Data.OpaqueConstructions"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  parameter Modelica.SIunits.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));

  parameter Modelica.SIunits.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1)
    "Sample period of component";


  Modelica.Blocks.Interfaces.RealInput Q_a_flow "Heat flow rate at surface a"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput Q_b_flow "Heat flow rate at surface b"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput T_a "Temperature at surface a"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput T_b "Temperature at surface b"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

protected
  parameter Modelica.SIunits.Time startTime(fixed=false) "First sample time instant";

  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

  // Note that retVal should always be 0, as any error in the CTF
  // code need to be handled with a call to ModelicaError.
  output Integer retVal "Return value of the CTF calculation";

  CTFData ctfData=CTFData()
    "Extentable array, used to store history of rate of heat flows";

initial equation
  startTime = time;
  // fixme: we probably want to output some steady-state temperatures?
 // T_a = T_a_start;
 // T_b = T_b_start;
equation
  sampleTrigger = sample(startTime, samplePeriod);

   when {sampleTrigger, initial()} then
    firstTrigger = time <= startTime + samplePeriod/2;
    // Output the previous temperature plus some increment

    (T_a, T_b, retVal) = Buildings.HeatTransfer.Conduction.BaseClasses.computeCTF(
      ctfData = ctfData,
      t =        time,
      Q_a_flow = pre(Q_a_flow),
      Q_b_flow = pre(Q_b_flow));

  end when;
  annotation (Icon(graphics={
        Text(
          extent={{52,78},{92,44}},
          lineColor={28,108,200},
          textString="T_a"),
        Text(
          extent={{50,-40},{90,-74}},
          lineColor={28,108,200},
          textString="T_b"),
        Text(
          extent={{-86,76},{-46,42}},
          lineColor={28,108,200},
          textString="Q_a_flow"),
        Text(
          extent={{-88,-42},{-48,-76}},
          lineColor={28,108,200},
          textString="Q_b_flow")}), Documentation(info="<html>
<p>
Block that implements the Conduction Transfer Function method.
</p>
<p>
Input are the heat flow rates at both surfaces.
At the sample interval <code>samplePeriod</code>, the
surface temperatures are recomputed and assigned
to the output signals.
</p>
<p>
fixme: add documentation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2016, by Michael Wetter:<br/>
First implementation of the interfaces and parameters.
</li>
</ul>
</html>"));
end ConductionTransferFunction;
