function plot_pcspace(points, output_path)

fig = figure('Visible','off');
hold on;
scatter(points.SR.all_PC(:,1),  points.SR.all_PC(:,2),  'g+');
scatter(points.SNR.all_PC(:,1), points.SNR.all_PC(:,2), 'g.');
scatter(points.FR.all_PC(:,1),  points.FR.all_PC(:,2),  'k+');
scatter(points.FNR.all_PC(:,1), points.FNR.all_PC(:,2), 'k.');
xlabel('First principal component'), ylabel('Second principal component');
title('PC space projection'), axis('tight');
grid on;
axis([-700 700 -400 400]);
set(gca,'xtick',-700:100:700);
set(gca,'ytick',-400:50:400);
legend('Success & R', 'Success & NR', 'Failure & R', 'Failure & NR');
hold off;

mkdir(output_path);
print(fig, [output_path '/pcspace.png'], '-dpng');

end

