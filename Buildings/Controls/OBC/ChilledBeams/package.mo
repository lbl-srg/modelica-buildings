within Buildings.Controls.OBC;
package ChilledBeams "Package containing sequences implemented for control of chilled beam systems"
annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}),
  Documentation(info="<html>
    <p>
    This package contains control sequences for chilled beam systems. The sequence
    of operations were compiled after a literature review of the best practices
    in the industry.
    </p>
    <p>
    The package consist of two main components:
    <ul>
    <li>
    the system controller <a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.System.Controller\">
    Buildings.Controls.OBC.ChilledBeams.System.Controller</a> and
    </li>
    <li>
    the zone terminal controller <a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.Terminal.Controller\">
    Buildings.Controls.OBC.ChilledBeams.Terminal.Controller</a>.
    </li>
    </ul>
    </p>
    <p>
    The two controllers are used as shown in the schematic below. The system controller
    is responsible for controlling the secondary chilled water supply pumps and 
    the pressure-relief bypass valve. The zone terminal controller is responsible for
    the chilled water control valve for the zone chilled beam manifold, as well as 
    the CAV terminal reheat and damper components.    
    </p>
    <p align=\"center\">
    <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Controls/OBC/ChilledBeams/ChilledBeamsSchematic.png\" border=\"1\"/>
    </p>
    </html>"));
end ChilledBeams;
