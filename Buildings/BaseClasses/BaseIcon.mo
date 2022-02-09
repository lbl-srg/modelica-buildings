within Buildings.BaseClasses;
block BaseIcon "Base icon"

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-46,158},{52,110}},
          textColor={0,0,255},
          textString="%name")}),
Documentation(
info="<html>
<p>
Basic class that provides a label with the component name above the icon.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaseIcon;
