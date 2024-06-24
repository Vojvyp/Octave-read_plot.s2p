clear
clc

file_name = cell(1, 4);
freq = cell(1, 4);
s11 = cell(1, 4);
s12 = cell(1, 4);
s21 = cell(1, 4);
s22 = cell(1, 4);

target_value = 560;
save_dir = 'grafy_obrazky/';
title_1 = "B2 out3";
title_2 = "B2 out4";

file_name{1}="B_II_out3_ant1";
file_name{2}="B_II_out3_ant2";
file_name{3}="B_II_out3_ant3";
file_name{4}="B_II_out3_ant4";
file_name{5}="B_II_out4_ant1";
file_name{6}="B_II_out4_ant2";
file_name{7}="B_II_out4_ant3";
file_name{8}="B_II_out4_ant4";

for i = 1:8
  freq{i} = sprintf('freq%d', i);
  s11{i} = sprintf('s11_%d', i);
  s12{i} = sprintf('s12_%d', i);
  s21{i} = sprintf('s21_%d', i);
  s22{i} = sprintf('s22_%d', i);
end
for i = 1:8
[freq{i}, s11{i}, s12{i}, s21{i}, s22{i}]=load_s2p(file_name{i});
[min_difference, row] = min(abs(freq{i} - target_value));
end
hf = figure ();

%----------------------S21 data plot--------------------------------------------
subplot (411);
for i=1:4
plot(freq{i}(1:row, :),s21{i}(1:row, :),'LineWidth', 2);
hold on
end
title(title_1)
xlabel('Frequency |MHz|')
ylabel('S21 |dB|')
legend('ant1 |s_{21}|','ant2 |s_{21}|','ant3 |s_{21}|','ant4 |s_{21}|');
set(gca, 'FontSize', 14)

h = legend;
set(h, 'FontSize', 14);
grid on

xticks(0:20:target_value);
yticks(-80:10:15);
%----------------------S11 data plot--------------------------------------------
subplot (412);
for i=1:4
plot(freq{i}(1:row, :),s11{i}(1:row, :),'LineWidth', 2);
hold on
end

xlabel('Frequency |MHz|')
ylabel('S11 |dB|')
legend('ant1 |s_{11}|','ant2 |s_{11}|','ant3 |s_{11}|','ant4 |s_{11}|');
set(gca, 'FontSize', 14)

h = legend;
set(h, 'FontSize', 14);
grid on

xticks(0:20:target_value);
yticks(-90:10:10);
%----------------------S21 data plot--------------------------------------------
subplot (413);
for i=5:8
plot(freq{i}(1:row, :),s21{i}(1:row, :),'LineWidth', 2);
hold on

end

title(title_2)
xlabel('Frequency |MHz|')
ylabel('S21 |dB|')
legend('ant1 |s_{21}|','ant2 |s_{21}|','ant3 |s_{21}|','ant4 |s_{21}|');
set(gca, 'FontSize', 14)

h = legend;
set(h, 'FontSize', 14);
grid on

xticks(0:20:target_value);
yticks(-90:10:10);
%----------------------S11 data plot--------------------------------------------
subplot (414);
for i=5:8
plot(freq{i}(1:row, :),s11{i}(1:row, :),'LineWidth', 2);
hold on
end


xlabel('Frequency |MHz|')
ylabel('S11 |dB|')
legend('ant1 |s_{11}|','ant2 |s_{11}|','ant3 |s_{11}|','ant4 |s_{11}|');
set(gca, 'FontSize', 14)

h = legend;
set(h, 'FontSize', 14);
grid on

xticks(0:20:target_value);
yticks(-90:10:10);

% Nastavení velikosti obrázku v pixelech (např. 1200x800)
width = 3629;
height = 1851;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 width/100 height/100]);
set(gcf, 'PaperSize', [width/100 height/100]);

% Uložení grafu do PNG souboru
print(fullfile(save_dir, strcat(title_1, '_', title_2, '.png')), '-dpng', '-r72');



