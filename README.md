# Example Platform engineering repo for building serverless infra
A terraform repository that allows for self-service via code for developers to create a serverless AWS API that uses a single API gateway with lambda functions at various endpoints. It supports authorization via cognito user pools and by default creates python3.10 'helloworld'  lambda functions at every endpoint.

# Article:
## A Practical Introduction to Platform Engineering: 
#### Building a Self-Service Code Repository with Terraform and AWS to improve the API development experience

## Intro:
In today's fast-paced software development landscape, platform engineering has emerged as a crucial discipline that enables organizations to streamline and scale their software delivery processes. Platform engineers play a pivotal role in creating robust and efficient infrastructure, tools, and services that empower development teams to deliver high-quality software at an accelerated pace. In this tutorial, we will explore the concept of platform engineering and demonstrate how to build a self-service code repository, which is a key component of a platform engineering ecosystem.

## What is Platform Engineering?
Platform engineering is the practice of creating and maintaining a set of shared tools, services, and infrastructure that empower development teams to focus on building applications without worrying about the underlying complexities. It involves designing and implementing a cohesive platform that provides self-service capabilities, automation, scalability, and reliability.

## Benefits of Platform Engineering:

- Increased developer productivity: By providing self-service tools and services, platform engineering reduces the friction in the development process, enabling developers to work efficiently and focus on core business logic.
- Consistent and standardized practices: A well-designed platform enforces best practices and standards across the organization, leading to consistent code quality, improved maintainability, and easier collaboration.
- Faster time-to-market: With self-service capabilities and automation, platform engineering enables faster delivery of applications, reducing time spent on repetitive tasks and manual configuration.
- Scalability and resilience: A robust platform architecture ensures that applications can scale seamlessly and handle increased workloads, while also providing resilience and fault tolerance.

## Building a Self-Service Code Repository:
A self-service code repository allows development teams to manage, share, and collaborate on code efficiently. It provides a centralized location for storing code and associated resources, such as documentation, libraries, and dependencies. Here's how you can build a self-service code repository:

Choose a Version Control System (VCS):
Select a VCS that suits your organization's needs, such as Git, Mercurial, or Subversion. Git is the most popular choice due to its distributed nature, ease of use, and robust feature set.

Set up a Centralized Repository:
Create a centralized repository to serve as the primary code repository for your organization. This repository will house the codebase and allow teams to clone, contribute, and collaborate. Choose a hosting provider like GitHub, GitLab, or Bitbucket to host the repository.

Define Repository Structure:
Establish a clear structure for organizing code within the repository. Consider using a modular approach based on the organization's projects, services, or domains. This structure should be intuitive and easy to navigate, enabling developers to find and contribute code seamlessly.

Enable Access Control:
Implement access controls to ensure that only authorized individuals or teams can access the code repository. Define user roles and permissions, such as read-only access, pull requests, or repository administration, according to team responsibilities and project requirements.

Encourage Code Documentation:
Encourage developers to document their code effectively within the repository. This documentation should include guidelines, README files, code comments, and any other relevant information that helps other developers understand and utilize the codebase effectively.

Automate Code Quality Checks:
Integrate automated code quality checks into the repository workflow using tools like linters, static code analyzers, and unit testing frameworks. These checks ensure that code submitted to the repository meets predefined standards and reduces the burden of manual code reviews.

Implement CI/CD Pipelines:
Integrate your self-service code repository with a Continuous Integration/Continuous Deployment (CI/CD) platform. This enables automated build, test, and deployment processes, ensuring that changes pushed to the repository are thoroughly tested and seamlessly deployed to the target environments.

Provide Collaboration Tools:
Leverage collaboration features of your chosen V
