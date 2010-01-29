within Buildings.Fluid.Movers;
model FlowMachine_Nrpm "Centrifugal pump with ideally controlled speed"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine;
  parameter Boolean use_N_in = true
    "Get the rotational speed from the input connector";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_const = N_nominal
    "Constant rotational speed" annotation(Dialog(enable = not use_N_in));
  Modelica.Blocks.Interfaces.RealInput N_in(unit="1/min") if use_N_in
    "Prescribed rotational speed" 
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(
          visible=use_N_in,
          extent={{14,98},{178,82}},
          textString="N_in [rpm]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<HTML>
<p>This model describes a centrifugal pump (or a group of <tt>nParallel</tt> pumps) with prescribed speed, either fixed or provided by an external signal.
<p>The model extends <tt>PartialPump</tt>
<p>If the <tt>N_in</tt> input connector is wired, it provides rotational speed of the pumps (rpm); otherwise, a constant rotational speed equal to <tt>N_const</tt> (which can be different from <tt>N_nominal</tt>) is assumed.</p>
</HTML>",
      revisions="<html>
<ul>
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
       Model added to the Buildings library. 
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));

protected
  Modelica.Blocks.Interfaces.RealInput N_in_internal(unit="1/min")
    "Needed to connect to conditional connector";
equation
  // Connect statement active only if use_p_in = true
  connect(N_in, N_in_internal);
  // Internal connector value when use_p_in = false
  if not use_N_in then
    N_in_internal = N_const;
  end if;
  // Set N with a lower limit to avoid singularities at zero speed
  N = max(N_in_internal,1e-3) "Rotational speed";

end FlowMachine_Nrpm;
