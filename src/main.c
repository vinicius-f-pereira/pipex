#include "../includes/pipex.h"

int	main(int argc, char **argv, char *const envp[])
{
	int	fd[2];
	int	pid1;
	int	pid2;
	// int	pid3;
	char	*path;
	// char	**flags;
	(void)argv;
	if (5 != argc)
	{
		ft_printf("%s\n", "Not In");
		return (0);
	}
	if (pipe(fd) == -1)	
		return (1);
	pid1 = fork();
	if (pid1 < 0)	
		return (2);
	if (pid1 == 0)
	{
		dup2(fd[1], STDOUT_FILENO);
		close(fd[0]);
		close(fd[1]);
		execve("/usr/bin/where", &argv[3], envp);

	}
	pid2 = fork();
	if (pid2 < 0)
		return (3);
	if (pid2 == 0)
	{
		path = malloc(ft_strlen(argv[3]));
		read(1, path, ft_strlen(argv[3]));
		close(fd[0]);
		close(fd[1]);
	}
	close(fd[0]);
	close(fd[1]);
	waitpid(pid1, NULL, 0);
	waitpid(pid2, NULL, 0);
	ft_printf("%s\n", "In");
	return (0);
}
