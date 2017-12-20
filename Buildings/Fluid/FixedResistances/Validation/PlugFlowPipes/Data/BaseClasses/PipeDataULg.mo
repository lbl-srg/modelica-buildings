within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses;
partial record PipeDataULg "Base class for ULg experimental data"
  extends PipeDataBaseDefinition;
  parameter Modelica.SIunits.Temp_C T_start_in = 20
    "Initial temperature at inlet";
  parameter Modelica.SIunits.Temp_C T_start_out = 20
    "Initial temperature at outlet";
  parameter Modelica.SIunits.MassFlowRate m_flowIni = 0
    "Mass flow initialization";
  annotation (Documentation(info="<html>
<p>
This record contains information of an aproximately 15 minutes long test bench
carried out at the University of Liège.
</p>

<h4>Data structure</h4>
<p>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<h4>Test procedure</h4>
<p>
Before to perform a test, the water city network is pushed inside
the approximately 39 meter long studied pipe during about 10 minutes
to be sure that it is at the same temperature. 
During this time period, valves V3 and V1 are opened, the boiler is off and
the valve V2 is closed.
</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. 
The boiler is started to reach the setpoint hot water temperature. 
When the temperature setpoint is achieved, data starts to be recorded,
the valve V1 is opened and the valve V2 is closed at the same time
to supply the studied pipe in hot water. 
After the outlet pipe temperature is stabilized, the boiler is shut off.
</p>
<p>
During the test, the ambient temperature is equal to <i>18</i>&circ;C and
the mass flow rate is set to <i>1.245</i> kg/s.</p>

<h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test rig at ULg\"
src=\"modelica://Buildings/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<h4>Pipe characteristics</h4>

<ul>
<li>Metal density about 7800 kg/m<sup>3</sup></li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal
to the initial temperature of the water (cooling before test)
</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed
at 5 W/m<sup>2</sup>K (from internal model) due to insulation.  
The pipe is insulated by Tubolit 60/13 (13mm of thickness) whose
nominal thermal coefficient is inferior 0.04. 
Notice the insulation is quite aged therefore
the nominal thermal coefficient could be higher
</li>
<li>
Heat transfer coefficient between water and pipe is a function of
the fluid temperature (determined by EES software).
</li>
</ul>

</html>"));
end PipeDataULg;
