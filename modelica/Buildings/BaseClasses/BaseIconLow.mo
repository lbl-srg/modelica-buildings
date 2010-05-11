within Buildings.BaseClasses;
model BaseIconLow "Base icon with model name below the icon"
  annotation (Icon(graphics={Text(
          extent={{-50,-84},{48,-132}},
          lineColor={0,0,255},
          textString=
               "%name")}));
end BaseIconLow;
