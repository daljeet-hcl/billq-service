# Development Container Setup

This project includes a dev container configuration for consistent development environments using Docker or Podman.

## Prerequisites

- **Docker**: Install from [docker.com](https://docker.com)
- **Podman**: Install from [podman.io](https://podman.io)
- **VS Code**: Install from [code.visualstudio.com](https://code.visualstudio.com)
- **Dev Containers Extension**: In VS Code, install the "Dev Containers" extension (ms-vscode-remote.remote-containers)

## What's Included

- Java 25 JDK
- Apache Maven (latest)
- Git
- VS Code extensions for Java, Spring Boot, Maven, and debugging
- Automatic port forwarding for port 8083 (billq-service)
- Auto-formatted Java files on save

## Quick Start

### Option 1: Open with Docker (Recommended)

1. Open the repository folder in VS Code
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Type "Dev Containers: Reopen in Container"
4. Select "billq-service (Java 25)"
5. Wait for the container to build (first time takes ~2-3 minutes)

The container will automatically:
- Download dependencies
- Run initial verification
- Set up port forwarding

### Option 2: Switch to Podman Instead

VS Code Dev Containers can use Podman as the container runtime. To use Podman instead of Docker:

1. Install Podman: `brew install podman` (macOS) or your system's package manager
2. In VS Code settings (`Ctrl+,`), search for "dev containers docker path"
3. Under "Dev Containers: Docker Path", enter: `podman`
4. Or set the environment variable: `export DOCKER_HOST="unix:///run/podman/podman.sock"`
5. Then follow "Quick Start" steps above

**Note**: Podman socket may need to be started:
```bash
podman machine start        # On macOS
podman system connection default podman-machine-default  # If using named connections
```

### Option 3: Command Line with Docker

```bash
# Build and start the dev container
docker build -t billq-devcontainer .devcontainer

# Run with port forwarding
docker run -it --rm -v $(pwd):/workspace -p 8083:8083 billq-devcontainer /bin/bash

# Inside the container, build and run:
cd /workspace
mvn clean verify -DskipTests
mvn spring-boot:run
```

### Option 4: Command Line with Podman

```bash
# Build with Podman
podman build -t billq-devcontainer .devcontainer

# Run with port forwarding
podman run -it --rm -v $(pwd):/workspace -p 8083:8083 billq-devcontainer /bin/bash

# Inside the container, build and run:
cd /workspace
mvn clean verify -DskipTests
mvn spring-boot:run
```

## Testing with Both Docker and Podman

### Test Docker First

```bash
# Make sure Docker daemon is running
docker ps

# Open in VS Code with Docker as default (Docker is VS Code's default)
# Follow "Quick Start - Option 1" above
```

### Test Podman (Switch Runtime)

1. **Start Podman** (if not already running):
   ```bash
   podman machine start          # macOS/Windows
   # On Linux, Podman usually runs as-is
   ```

2. **Verify Podman is accessible**:
   ```bash
   podman ps
   podman system info
   ```

3. **Switch VS Code to use Podman**:
   - Press `Ctrl+Shift+P`, search "Preferences: Open Settings (JSON)"
   - Add or modify:
     ```json
     "dev.containers.dockerPath": "podman"
     ```
   - Alternatively, set environment:
     ```bash
     export DOCKER_HOST="unix:///run/podman/podman.sock"
     ```

4. **Reopen in Container**:
   - Close the current container (if open)
   - Press `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
   - VS Code will now use Podman

5. **Verify it's using Podman**:
   - Check the Dev Containers extension log output
   - You should see Podman commands being run

## Development Workflow

Once inside the container (via VS Code or command line):

### Build and Test
```bash
mvn clean verify
mvn test
mvn test -Dtest=BillqServiceApplicationTests
```

### Run Locally
```bash
mvn spring-boot:run
```

Access at: http://localhost:8083/billq/123

### Stop the Running App
Press `Ctrl+C` in the terminal

## Environment Variables

Set custom environment variables in the devcontainer:

1. Modify `.devcontainer/devcontainer.json`:
   ```json
   "remoteEnv": {
     "JAVA_HOME": "/usr/local/sdkman/candidates/java/current",
     "price": "Your custom message"
   }
   ```

2. Or pass at runtime (command line):
   ```bash
   docker run -e price="Custom message" ... billq-devcontainer
   ```

## Troubleshooting

### "Dev Containers extension not found"
- Install "Dev Containers" extension in VS Code (ms-vscode-remote.remote-containers)

### Podman socket issues on macOS
```bash
# Start Podman machine if not running
podman machine start

# Check socket status
podman system info | grep sock
```

### Container build fails
- Clear Docker/Podman cache: `docker system prune -a` or `podman system prune -a`
- Rebuild: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

### Port 8083 already in use
- Kill existing process: `lsof -ti:8083 | xargs kill -9`
- Or use different port: Modify `devcontainer.json` `forwardPorts`

### Maven/Java not found in container
- Verify the container image built successfully
- Rebuild: `Ctrl+Shift+P` → "Dev Containers: Rebuild Without Cache"

## File Structure

```
.devcontainer/
  devcontainer.json      ← Configuration for VS Code Dev Containers
  Dockerfile             ← Custom image build (extends Microsoft's Java image)
  DEVCONTAINER_README.md ← This file
```

## More Information

- [VS Code Dev Containers Docs](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Containers Spec](https://containers.dev/)
- [Docker vs Podman](https://podman.io/)
